//
//  MessagesViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 11/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import PubNub

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController:NSFetchedResultsController<Channel>!{
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
    var currentUserId:Int32 = 0
    let context:NSManagedObjectContext = CoreDataManager.shared.context
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserId = Int32(ClientAPI.currentUser!.user_id)
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.cellId)
        tableView.register(UINib.init(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: ChatTableViewCell.cellId)
        title = "Messages"
        fetchedResultsController = getResultController()
        let chatController = (UIApplication.shared.delegate as! AppDelegate).chatController
        chatController?.updatePresence()
        chatController?.client?.addListener(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selected = tableView.indexPathForSelectedRow, !selected.isEmpty {
            tableView.deselectRow(at: selected, animated: false)
        }
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
                let Channel = fetchedResultsController.object(at: indexPath)
                guard let cell = tableView.cellForRow(at: indexPath) else { break }
                configureCell(cell: cell as! ChatTableViewCell, channel: Channel)
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
    func configureCell(cell: ChatTableViewCell, channel: Channel) {
        cell.configureCell(currentUserId:currentUserId, channel:channel)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else { return nil }
        return sections[section].indexTitle ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellId) as! ChatTableViewCell
        let Channel = fetchedResultsController.object(at: indexPath)
        configureCell(cell: cell, channel: Channel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: "showChat", sender: channel)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    private func getResultController(withFilter:String? = nil) -> NSFetchedResultsController<Channel> {
        let request:NSFetchRequest<Channel> = Channel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "recentMessage.time", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.includesSubentities = true
        if let text = withFilter {
            request.predicate = NSPredicate(format: "ANY users.full_name CONTAINS[cd] %@", text)
        }
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        return controller;
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" {
            guard let vc = segue.destination as? ChatViewController else {
                return
            }
            guard let channel = sender as? Channel else {
                return
            }
            vc.channel = channel
            
        }
    }
    

}
extension MessagesViewController: PNObjectEventListener{
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        if event.data.presence.uuid != client.uuid(){
            if event.data.presenceEvent != "state-change" {
                if let uuid = Int32(event.data.presence.uuid!) {
                    if let objects = fetchedResultsController.fetchedObjects{
                        let  channels = objects.filter(
                        { ($0.users?.array as! [ChatUser]).contains(where: {$0.user_id == uuid} )})
                        var paths = [IndexPath]()
                        for (index, channel) in objects.enumerated() {
                            if channels.contains(channel) {
                                paths.append(IndexPath(row: index, section: 0))
                            }
                            
                        }
                        if paths.count > 0 {
                            DispatchQueue.main.async {
                                self.tableView.reloadRows(at: paths, with: .none)
                            }
                        }
                        
                    }
                }
            }
        }
    }
}

extension MessagesViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            fetchedResultsController = getResultController(withFilter: searchText)
        }
        else {
            clearSearch()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearch()
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clearSearch()
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    func clearSearch() {
        fetchedResultsController = getResultController()
        try? fetchedResultsController.performFetch()
    }
}
