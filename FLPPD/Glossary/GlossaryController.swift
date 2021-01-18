//
//  GlossaryController.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import CoreData


class GlossaryController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,NSFetchedResultsControllerDelegate {
    var fetchedResultsController:NSFetchedResultsController<GlossaryItem>!{
        didSet {
            fetchedResultsController.delegate = self
            do{
                try fetchedResultsController.performFetch()
                tableView.reloadData()
            }
            catch{
                    dprint(error.localizedDescription)
            }
        }
    }
    let context:NSManagedObjectContext = CoreDataManager.shared.context
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomOffset: NSLayoutConstraint!
    var searching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController = getResultController()
        tableView.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(GlossaryController.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GlossaryController.hideKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        searchBar.delegate = self
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    internal func getResultController(withFilter:String? = nil) -> NSFetchedResultsController<GlossaryItem> {
        let request:NSFetchRequest<GlossaryItem> = GlossaryItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "folder", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        var needFilter = false
        if let text = withFilter, !text.isEmpty {
            request.predicate = NSPredicate(format: "ANY title CONTAINS[cd] %@", text)
            needFilter = true
        }
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: needFilter ? nil : "folder", cacheName: nil)
        return controller;
    }
    // keyboard
    func getKeyboardInfo(info:[AnyHashable:Any]) -> (UIViewAnimationCurve, Double, CGSize){
        //  Getting keyboard animation.
        var _animationCurve:UIViewAnimationCurve = .easeOut
        if let curve = (info[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue {
            _animationCurve = UIViewAnimationCurve(rawValue:curve) ?? .easeOut
        }
        //  Getting keyboard animation duration
        var _animationDuration:Double = 0.25
        if let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            
            //Saving animation duration
            if duration != 0.0 {
                _animationDuration = duration
            }
        }
        var _kbSize = CGSize()
        if let kbFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let screenSize = UIScreen.main.bounds
            //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
            let intersectRect = kbFrame.intersection(screenSize)
            
            if intersectRect.isNull {
                _kbSize = CGSize(width: screenSize.size.width, height: 0)
            } else {
                _kbSize = intersectRect.size
            }
        }
        return (_animationCurve, _animationDuration, _kbSize)
    }
    @objc func showKeyboard(_ note:Notification){
        if let info = (note as NSNotification?)?.userInfo {
            let (_animationCurve, _animationDuration, _kbSize) = getKeyboardInfo(info: info)
            UIView.setAnimationCurve(_animationCurve)
            UIView.animate(withDuration: _animationDuration, animations:{[unowned self] in
                self.bottomOffset.constant = -_kbSize.height
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            } )
        }
    }
    @objc func hideKeyboard(_ note:Notification){
        if let info = (note as NSNotification?)?.userInfo {
            let (_animationCurve, _animationDuration, _) = getKeyboardInfo(info: info)
            UIView.setAnimationCurve(_animationCurve)
            UIView.animate(withDuration: _animationDuration, animations:{[unowned self] in
                self.bottomOffset.constant = 0
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            } )
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try? fetchedResultsController.performFetch()
    }
    // fetched controller
    // 1
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    // 2
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    // 3
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    // 4
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let item = fetchedResultsController.object(at: indexPath)
                guard let cell = tableView.cellForRow(at: indexPath) else { break }
                configure(cell: cell as! GlossaryCell, withItem: item)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    // 5
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // table view
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GlossaryCell.cellID, for: indexPath) as! GlossaryCell
        let item = fetchedResultsController.object(at: indexPath)
        configure(cell: cell, withItem: item)
        return cell
    }
    func configure(cell:GlossaryCell, withItem item:GlossaryItem) {
        cell.ItemTitleLabel.text = item.title
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searching {
            return nil
        }
        let view = UIView(frame: CGRect(x: 25, y: 0, width: 320, height: 50) )
        let label = UILabel(frame:CGRect(x: 15, y: 0, width: 320, height: 50))
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Colors.navFont
        let top = view.topAnchor.anchorWithOffset(to: label.topAnchor).constraint(equalToConstant: 25)
        let left  =  view.leftAnchor.anchorWithOffset(to: label.leftAnchor).constraint(equalToConstant: 14)
        top.isActive = true
        left.isActive = true
        label.text = fetchedResultsController.sectionIndexTitles[section]
        view.backgroundColor = Colors.backgoundGrayColor
        view.isOpaque = false
        label.backgroundColor = UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searching {
            return 0
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: "showItem", sender: item)
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItem" {
            let item = sender as! GlossaryItem
            let vc = segue.destination as! GlossaryContentController
            vc.item = item
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = nil
        searchBar.showsCancelButton = false
        fetchedResultsController = getResultController()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchedResultsController = getResultController(withFilter: searchText)
    }
    
}
