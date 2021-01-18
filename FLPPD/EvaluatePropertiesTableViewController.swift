//
//  EvaluatePropertiesTableViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 1/28/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class EvaluatePropertiesTableViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let coreDataController = CoreDataController()
  private let evalPropertyType = Variable(EvalPropertyType.flip)
  private let flipPropertiesTableView = UITableView()
  private let rentalPropertiesTableView = UITableView()
  private let newPropertyButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: nil, action: nil)
  private let rentalFlipControl = UISegmentedControl(items:["Rentals","Flips"])
  private var flipProperties:Variable<[FlipProperty]> = Variable([])
  private var rentalProperties:Variable<[RentalProperty]> = Variable([])
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    view.addSubview(flipPropertiesTableView)
    view.addSubview(rentalPropertiesTableView)
    flipPropertiesTableView.pinToSuperView()
    rentalPropertiesTableView.pinToSuperView()
    flipPropertiesTableView.backgroundColor = UIColor.groupTableViewBackground
    rentalPropertiesTableView.backgroundColor = UIColor.groupTableViewBackground
    flipPropertiesTableView.separatorStyle = .none
    rentalPropertiesTableView.separatorStyle = .none
    Helper.navigationWithGray((navigationController?.navigationBar)!)
    rentalFlipControl.tintColor = UIColor.darkerGold
    rentalFlipControl.selectedSegmentIndex = 0
    self.navigationController?.navigationBar.topItem?.titleView = rentalFlipControl
    self.navigationController?.navigationBar.topItem?.rightBarButtonItem = newPropertyButton
    newPropertyButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      let vc = NewEvaluatePropertyViewController()
      vc.evalPropertyType = self.evalPropertyType.value
      vc.coreDataController = self.coreDataController
      self.present(vc, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    flipPropertiesTableView.register(EvalPropertyCell.self, forCellReuseIdentifier: "flipPropertyCell")
    rentalPropertiesTableView.register(EvalPropertyCell.self, forCellReuseIdentifier: "flipPropertyCell")
    flipPropertiesTableView.rowHeight = 77
    rentalPropertiesTableView.rowHeight = 77
    flipProperties.asObservable().bind(to: flipPropertiesTableView.rx.items(cellIdentifier: "flipPropertyCell",cellType:EvalPropertyCell.self),curriedArgument: {row, element, cell in
      cell.streetAddressLabel.text = element.street
      cell.cityStateLabel.text = element.city! + ", " + element.state!
      cell.thumbnailView.image = element.thumbnail == nil ? UIImage(named: "placeHolder") : element.thumbnail as? UIImage
      cell.priceLabel.textColor = UIColor.darkgreen
      if let purchasePrice = element.worksheet?.purchasePrice,purchasePrice.isGreaterThan(0) {
        cell.priceLabel.text = purchasePrice.dollarFormat()
      }
    }).disposed(by: disposeBag)
    rentalProperties.asObservable().bind(to: rentalPropertiesTableView.rx.items(cellIdentifier: "flipPropertyCell",cellType:EvalPropertyCell.self),curriedArgument: {row, element, cell in
      cell.streetAddressLabel.text = element.street
      cell.cityStateLabel.text = element.city! + ", " + element.state!
      cell.thumbnailView.image = element.thumbnail == nil ? UIImage(named: "placeHolder") : element.thumbnail as? UIImage
      cell.priceLabel.textColor = UIColor.darkerGold
      if let purchasePrice = element.worksheet?.purchasePrice,purchasePrice.isGreaterThan(0) {
        cell.priceLabel.text = purchasePrice.dollarFormat()
      }
    }).disposed(by: disposeBag)
    flipPropertiesTableView.rx.itemSelected.subscribe(onNext:{[unowned self](indexPath)->Void in
      self.flipPropertiesTableView.deselectRow(at: indexPath, animated: true)
      let detailVC = EvalDetailViewController()
      detailVC.editContext = self.coreDataController.persistentContainer.newBackgroundContext()
      detailVC.evalPropertyType = EvalPropertyType.flip
      detailVC.property = self.flipProperties.value[indexPath.row]
      detailVC.coreDataController = self.coreDataController
      self.navigationController?.pushViewController(detailVC, animated: true)
    }).disposed(by: disposeBag)
    
    rentalPropertiesTableView.rx.itemSelected.subscribe(onNext:{[unowned self](indexPath)->Void in
      self.rentalPropertiesTableView.deselectRow(at: indexPath, animated: true)
      let detailVC = EvalDetailViewController()
      detailVC.editContext = self.coreDataController.persistentContainer.newBackgroundContext()
      detailVC.evalPropertyType = EvalPropertyType.rental
      detailVC.property = self.rentalProperties.value[indexPath.row]
      detailVC.coreDataController = self.coreDataController
      self.navigationController?.pushViewController(detailVC, animated: true)
    }).disposed(by: disposeBag)
    
    getFlipProperties()
    getRentalProperties()
    NotificationCenter.default.rx.notification(Notification.Name(EvalPropertyType.flip.savedNotification)).subscribe(onNext:{[unowned self] Void in
      self.getFlipProperties()
    }).disposed(by: disposeBag)
    NotificationCenter.default.rx.notification(Notification.Name(EvalPropertyType.rental.savedNotification)).subscribe(onNext:{[unowned self] Void in
      self.getRentalProperties()
    }).disposed(by: disposeBag)
    evalPropertyType.asObservable().subscribe(onNext:{[unowned self](type)->Void in
      if type == EvalPropertyType.flip {
        self.flipPropertiesTableView.isHidden = false
        self.rentalPropertiesTableView.isHidden = true
      }else{
        self.flipPropertiesTableView.isHidden = true
        self.rentalPropertiesTableView.isHidden = false
      }
    }).disposed(by: disposeBag)
    rentalFlipControl.rx.selectedSegmentIndex.subscribe(onNext:{[unowned self](index)->Void in
      self.evalPropertyType.value = index == 0 ? EvalPropertyType.rental : EvalPropertyType.flip
    }).disposed(by: disposeBag)
    
  }
  
  func getFlipProperties(){
    do{
      self.flipProperties.value = try coreDataController.persistentContainer.viewContext.fetch(FlipProperty.fetchRequest())
    }catch let error as NSError  {
      dprint(" \(error), \(error.userInfo)")
    }
  }
  func getRentalProperties(){
    do{
      self.rentalProperties.value = try coreDataController.persistentContainer.viewContext.fetch(RentalProperty.fetchRequest())
    }catch let error as NSError  {
      dprint("\(error), \(error.userInfo)")
    }
  }
  
}
