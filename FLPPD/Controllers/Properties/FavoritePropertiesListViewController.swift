//
//  FavoritePropertiesListViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/06/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class FavoritePropertiesListViewController: UIViewController {
  
  //MARK: Properties
  private let refreshControl = UIRefreshControl()
    var user_id = ClientAPI.currentUser?.user_id
  fileprivate let properties: Variable<[FLPPDPropertyViewModel]> = Variable([])
  private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    //MARK:- view methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refreshControl.tintColor = UIColor.darkerGold
    tableView.addSubview(refreshControl)
    
    let tableViewCellNib = UINib(nibName: "PropertyFeedTableViewCell", bundle: nil)
    tableView.register(tableViewCellNib, forCellReuseIdentifier: "PropertyCells")
    properties.asObservable().bind(to:tableView.rx.items(cellIdentifier: "PropertyCells",cellType:PropertyFeedTableViewCell.self),curriedArgument: {row, property, cell in
        cell.configureCell(property: property)
    }).disposed(by: disposeBag)

    tableView.rx.itemSelected.subscribe(onNext:{[unowned self](indexPath)->Void in
      let property = self.properties.value[indexPath.row]
      let propertyViewModel = PropertyViewModel(property: property.flppdProperty)
      let cell = self.tableView.cellForRow(at: indexPath) as! PropertyFeedTableViewCell
      let avatarImage = cell.avatarImageView.image ?? #imageLiteral(resourceName: "tabIconProfile")
      let portraitImage = cell.defaultImageView.image ?? #imageLiteral(resourceName: "loginBackground")
      //segue
        let controller = UIStoryboard.init(name: "PropertyFeed", bundle: nil).instantiateViewController(withIdentifier: "PropertyDetailContainerViewController") as! PropertyDetailContainerViewController
      controller.avatarImage = avatarImage
      controller.portraitImage = portraitImage
      controller.propertyViewModel = propertyViewModel
        controller.hidesBottomBarWhenPushed = true
      self.navigationController!.pushViewController(controller, animated: true)
    }).disposed(by: disposeBag)
    
    refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext:{
      DispatchQueue.main.async(execute: {[unowned self]()->Void in
        self.getProperties()
        self.refreshControl.endRefreshing()
      })
    }).disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(Notification.Name("newProperties")).subscribe(onNext:{[unowned self] Void in
      self.getProperties()
    }).disposed(by: disposeBag)
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    tableView.rowHeight = 130
    tableView.delegate = self
    getProperties()
  }
  //MARK: - call propertu network
  func getProperties(){
    self.properties.value.removeAll()
    guard let observable = getFavoritePropertiesObservable() else{
      return
    }
    observable.subscribe(onNext:{viewModel in
      self.properties.value.append(viewModel)
    }).disposed(by: disposeBag)
  }
}
extension FavoritePropertiesListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let property = self.properties.value[indexPath.row]
        let propertyViewModel = PropertyViewModel(property: property.flppdProperty)
        let cell = self.tableView.cellForRow(at: indexPath) as! PropertyFeedTableViewCell
        let avatarImage = cell.avatarImageView.image ?? #imageLiteral(resourceName: "tabIconProfile")
        let portraitImage = cell.defaultImageView.image ?? #imageLiteral(resourceName: "loginBackground")
        //segue
        let controller = UIStoryboard.init(name: "PropertyFeed", bundle: nil).instantiateViewController(withIdentifier: "PropertyDetailContainerViewController") as! PropertyDetailContainerViewController
        controller.avatarImage = avatarImage
        controller.portraitImage = portraitImage
        controller.propertyViewModel = propertyViewModel
        controller.showStarred = false
        controller.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        dprint("action for cell:\(indexPath.row)")
        let action = UITableViewRowAction(style: .destructive, title: "Remove") { [weak self] (action, indexPath) in
            if let property = self?.properties.value[indexPath.row]{
                ClientAPI.default.updatePropertyFavorites(property_id: property.flppdProperty.id, setFavorite: false, completion: { (success) in
                    if success {
                        self?.getProperties()
                    }
                })
            }
        }
        return [action]
    }
    
}
