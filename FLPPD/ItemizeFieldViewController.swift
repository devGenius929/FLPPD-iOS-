//
//  NewItemizeFieldViewController.swift
//  FLPPD
//
//  Created by PC on 5/31/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CoreData
class ItemizeFieldViewController:UIViewController{
  var coreDataController:CoreDataController!
  var itemizeFieldMode:ItemizeFieldMode = .new
  private let disposeBag = DisposeBag()
  private let topItem = UINavigationItem()
  var property:Property!
  var itemizeField:ItemizeField?
  var itemizeItemType:ItemizeItemType = .PurchaseCosts
  private let itemizeFieldView:ItemizeFieldView = ItemizeFieldView()
  private let navBar = UINavigationBar()
  private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
  private let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    view.addSubview(itemizeFieldView)
    view.addSubview(navBar)
    navBar.barTintColor = UIColor.white
    let navBarTopConstraint = NSLayoutConstraint(item: navBar, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
    navBar.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    navBar.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    let itemizeFieldViewTopConstraint = NSLayoutConstraint(item: itemizeFieldView, attribute: .top, relatedBy: .equal, toItem: navBar, attribute: .bottom, multiplier: 1, constant: 0)
    itemizeFieldView.setBottomInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    itemizeFieldView.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    itemizeFieldView.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    NSLayoutConstraint.activate([navBarTopConstraint,itemizeFieldViewTopConstraint])
    cancelButton.tintColor = UIColor.darkerGold
    saveButton.tintColor = UIColor.darkerGold
    topItem.leftBarButtonItem = cancelButton
    topItem.rightBarButtonItem = saveButton
    navBar.items = [topItem]
    cancelButton.rx.tap.subscribe(onNext:{
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: self.disposeBag)
    switch itemizeItemType{
    case .PurchaseCosts:
      setupAsPurchaseCosts()
    case .RehabCosts:
      setupAsRehabCosts()
    case .HoldingCosts:
      setupAsHoldingCosts()
    case .SellingCosts:
      setupAsSellingCosts()
    case .Income:
      setupAsIncome()
    case .Expenses:
      setupAsExpenses()
    }
  }
  private func setupAsExpenses(){
    let characteristicOptions0 = [CharacteristicData(characteristic: .SetAmount, hideSegmentedControlIndex: [1,2], showSegmentedControlIndex: [3]),CharacteristicData(characteristic: .Percent, hideSegmentedControlIndex: [3], showSegmentedControlIndex: [1,2])]
    let characteristicOptions1 = [CharacteristicData(characteristic: .OfPrice, hideSegmentedControlIndex: [2], showSegmentedControlIndex: []),CharacteristicData(characteristic: .OfRent, hideSegmentedControlIndex: [], showSegmentedControlIndex: [2])]
    let characteristicOptions2 = [CharacteristicData(characteristic: .WithoutVacancy, hideSegmentedControlIndex: [], showSegmentedControlIndex: []),CharacteristicData(characteristic: .WithVacancy, hideSegmentedControlIndex: [], showSegmentedControlIndex: [])]
    let characteristicOptions3 = [CharacteristicData(characteristic: .PerMonth, hideSegmentedControlIndex: [], showSegmentedControlIndex: []),CharacteristicData(characteristic: .PerYear, hideSegmentedControlIndex: [], showSegmentedControlIndex: [])]

    itemizeFieldView.characteristicOptions[0].value = characteristicOptions0
    itemizeFieldView.characteristicOptions[1].value = characteristicOptions1
    itemizeFieldView.characteristicOptions[2].value = characteristicOptions2
    itemizeFieldView.characteristicOptions[3].value = characteristicOptions3
    guard let itemizeExpensesField = itemizeField as? ItemizedExpensesField else{
      topItem.title = "New Expense"
      itemizeFieldView.segmentedControls[0].selectedSegmentIndex = 0
      itemizeFieldView.segmentedControls[1].selectedSegmentIndex = 1
      itemizeFieldView.segmentedControls[2].selectedSegmentIndex = 0
      itemizeFieldView.segmentedControls[3].selectedSegmentIndex = 0
      itemizeFieldView.characteristics[0].value = characteristicOptions0[0]
      itemizeFieldView.characteristics[1].value = characteristicOptions1[1]
      itemizeFieldView.characteristics[2].value = characteristicOptions2[0]
      itemizeFieldView.characteristics[3].value = characteristicOptions3[0]
      saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
        let context = self.coreDataController.persistentContainer.viewContext
        let newItemizeField = ItemizedExpensesField(context: context)
        (self.property.worksheet as? RentalWorksheet)?.expenses?.addToItemizedExpenses(newItemizeField)
        self.savedItemizedExpensesField(newItemizeField,context: context)
        self.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
      return
    }
    topItem.title = "Edit Expense"
    itemizeFieldView.segmentedControls[0].selectedSegmentIndex = Int(itemizeExpensesField.characteristic1)
    itemizeFieldView.segmentedControls[1].selectedSegmentIndex = Int(itemizeExpensesField.characteristic2)
    itemizeFieldView.segmentedControls[2].selectedSegmentIndex = Int(itemizeExpensesField.characteristic3)
    itemizeFieldView.segmentedControls[3].selectedSegmentIndex = Int(itemizeExpensesField.characteristic4)
    itemizeFieldView.characteristics[0].value = characteristicOptions0[Int(itemizeExpensesField.characteristic1)]
    itemizeFieldView.characteristics[1].value = characteristicOptions1[Int(itemizeExpensesField.characteristic2)]
    itemizeFieldView.characteristics[2].value = characteristicOptions2[Int(itemizeExpensesField.characteristic3)]
    itemizeFieldView.characteristics[3].value = characteristicOptions3[Int(itemizeExpensesField.characteristic4)]
    itemizeFieldView.nameTF.text = itemizeExpensesField.name
    itemizeFieldView.amountTF.text = itemizeExpensesField.characteristic1 == ExpensesCharacteristic1.SetAmount.number ? itemizeExpensesField.setAmount?.stringValue : itemizeExpensesField.percentValue?.stringValue
    saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.savedItemizedExpensesField(itemizeExpensesField,context: self.coreDataController.persistentContainer.viewContext)
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
  private func setupAsIncome(){
    let characteristicOptions0 = [CharacteristicData(characteristic: .PerMonth, hideSegmentedControlIndex: [], showSegmentedControlIndex: []),CharacteristicData(characteristic: .PerYear, hideSegmentedControlIndex: [], showSegmentedControlIndex: [])]
    itemizeFieldView.characteristicOptions[0].value = characteristicOptions0
    
    guard let itemizeIncomeField = itemizeField as? ItemizedIncomeField else{
      topItem.title = "New Income"
      itemizeFieldView.segmentedControls[0].selectedSegmentIndex = 0
      itemizeFieldView.characteristics[0].value = characteristicOptions0[0]
      saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
        let context = self.coreDataController.persistentContainer.viewContext
        let newItemizeField = ItemizedIncomeField(context: context)
        (self.property.worksheet as? RentalWorksheet)?.income?.addToItemizedIncome(newItemizeField)
        self.savedItemizedIncomeField(newItemizeField,context: context)
        self.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
      return
    }
    topItem.title = "Edit Income"
    itemizeFieldView.segmentedControls[0].selectedSegmentIndex = Int(itemizeIncomeField.characteristic1)
    itemizeFieldView.characteristics[0].value = characteristicOptions0[Int(itemizeIncomeField.characteristic1)]
    itemizeFieldView.nameTF.text = itemizeIncomeField.name
    itemizeFieldView.amountTF.text = itemizeIncomeField.setAmount?.decimalFormat()
    saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.savedItemizedIncomeField(itemizeIncomeField,context: self.coreDataController.persistentContainer.viewContext)
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
  private func setupAsSellingCosts(){
    let characteristicOptions0 = [CharacteristicData(characteristic: .SetAmount, hideSegmentedControlIndex: [], showSegmentedControlIndex: []),CharacteristicData(characteristic: .Percent, hideSegmentedControlIndex: [], showSegmentedControlIndex: [])]
    itemizeFieldView.characteristicOptions[0].value = characteristicOptions0
    
    guard let itemizeSellingCostsField = itemizeField as? ItemizedSellingCostsField else{
      topItem.title = "New Selling Costs"
      itemizeFieldView.segmentedControls[0].selectedSegmentIndex = 0
      itemizeFieldView.characteristics[0].value = characteristicOptions0[0]
      saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
        let context = self.coreDataController.persistentContainer.viewContext
        let newItemizeField = ItemizedSellingCostsField(context: context)
        (self.property.worksheet as? FlipWorksheet)?.sellingCosts?.addToItemizedSellingCosts(newItemizeField)
        self.savedItemizedSellingCostsField(newItemizeField,context: context)
        self.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
      return
    }
    topItem.title = "Edit Selling Costs"
    itemizeFieldView.segmentedControls[0].selectedSegmentIndex = Int(itemizeSellingCostsField.characteristic1)
    itemizeFieldView.characteristics[0].value = characteristicOptions0[Int(itemizeSellingCostsField.characteristic1)]
    itemizeFieldView.nameTF.text = itemizeSellingCostsField.name
    itemizeFieldView.amountTF.text = itemizeSellingCostsField.characteristic1 == SellingCostsCharacteristic1.SetAmount.number ? itemizeSellingCostsField.setAmount?.stringValue : itemizeSellingCostsField.percentValue?.stringValue
    saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.savedItemizedSellingCostsField(itemizeSellingCostsField,context: self.coreDataController.persistentContainer.viewContext)
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
  private func setupAsHoldingCosts(){
    let characteristicOptions0 = [CharacteristicData(characteristic: .SetAmount, hideSegmentedControlIndex: [], showSegmentedControlIndex: [1]),CharacteristicData(characteristic: .Percent, hideSegmentedControlIndex: [1], showSegmentedControlIndex: [])]
    let characteristicOptions1 = [CharacteristicData(characteristic: .PerMonth, hideSegmentedControlIndex: [], showSegmentedControlIndex: []),CharacteristicData(characteristic: .PerYear, hideSegmentedControlIndex: [], showSegmentedControlIndex: [])]
    itemizeFieldView.characteristicOptions[0].value = characteristicOptions0
    itemizeFieldView.characteristicOptions[1].value = characteristicOptions1
    
    guard let itemizeHoldingCostsField = itemizeField as? ItemizedHoldingCostsField else{
      topItem.title = "New Holding Costs"
      itemizeFieldView.segmentedControls[0].selectedSegmentIndex = 0
      itemizeFieldView.segmentedControls[1].selectedSegmentIndex = 0
      itemizeFieldView.characteristics[0].value = characteristicOptions0[0]
      itemizeFieldView.characteristics[1].value = characteristicOptions1[0]
      saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
        let context = self.coreDataController.persistentContainer.viewContext
        let newItemizeField = ItemizedHoldingCostsField(context: context)
        (self.property.worksheet as? FlipWorksheet)?.holdingCosts?.addToItemizedHoldingCosts(newItemizeField)
        self.savedItemizedHoldingCostsField(newItemizeField,context: context)
        self.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
      return
    }
    topItem.title = "Edit Holding Costs"
    itemizeFieldView.segmentedControls[0].selectedSegmentIndex = Int(itemizeHoldingCostsField.characteristic1)
    itemizeFieldView.segmentedControls[1].selectedSegmentIndex = Int(itemizeHoldingCostsField.characteristic2)
    itemizeFieldView.characteristics[0].value = characteristicOptions0[Int(itemizeHoldingCostsField.characteristic1)]
    itemizeFieldView.characteristics[1].value = characteristicOptions1[Int(itemizeHoldingCostsField.characteristic2)]
    itemizeFieldView.nameTF.text = itemizeHoldingCostsField.name
    itemizeFieldView.amountTF.text = itemizeHoldingCostsField.characteristic1 == HoldingCostsCharacteristic1.SetAmount.number ? itemizeHoldingCostsField.setAmount?.stringValue : itemizeHoldingCostsField.percentValue?.stringValue
    saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.savedItemizedHoldingCostsField(itemizeHoldingCostsField,context: self.coreDataController.persistentContainer.viewContext)
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
  private func setupAsRehabCosts(){
    guard let itemizeRehabCostsField = itemizeField as? ItemizedRehabCostsField else{
      topItem.title = "New Rehab Costs"
      saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
        let context = self.coreDataController.persistentContainer.viewContext
        let newItemizeField = ItemizedRehabCostsField(context: context)
        self.property.worksheet?.rehabCosts?.addToItemizedRehabCosts(newItemizeField)
        self.savedItemizedRehabCostsField(newItemizeField,context: context)
        self.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
      return
    }
    topItem.title = "Edit Rehab Costs"
    itemizeFieldView.nameTF.text = itemizeRehabCostsField.name
    itemizeFieldView.amountTF.text = itemizeRehabCostsField.setAmount?.stringValue
    saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.savedItemizedRehabCostsField(itemizeRehabCostsField,context: self.coreDataController.persistentContainer.viewContext)
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
  private func setupAsPurchaseCosts(){
    let characteristicOptions0 = [CharacteristicData(characteristic: .SetAmount, hideSegmentedControlIndex: [1], showSegmentedControlIndex: [2]),CharacteristicData(characteristic: .Percent, hideSegmentedControlIndex: [], showSegmentedControlIndex: [1,2])]
    let characteristicOptions1 = [CharacteristicData(characteristic: .OfPrice, hideSegmentedControlIndex: [], showSegmentedControlIndex: []),CharacteristicData(characteristic: .OfLoan, hideSegmentedControlIndex: [], showSegmentedControlIndex: [])]
    let characteristicOptions2 = [CharacteristicData(characteristic: .PayUpfront, hideSegmentedControlIndex: [], showSegmentedControlIndex: []),CharacteristicData(characteristic: .WrapIntoLoan, hideSegmentedControlIndex: [], showSegmentedControlIndex: [])]
    itemizeFieldView.characteristicOptions[0].value = characteristicOptions0
    itemizeFieldView.characteristicOptions[1].value = characteristicOptions1
    itemizeFieldView.characteristicOptions[2].value = characteristicOptions2
    guard let itemizePurchaseCostsField = itemizeField as? ItemizedPurchaseCostsField else{
      topItem.title = "New Purchase Costs"
      itemizeFieldView.segmentedControls[0].selectedSegmentIndex = 0
      itemizeFieldView.segmentedControls[1].selectedSegmentIndex = 0
      itemizeFieldView.segmentedControls[2].selectedSegmentIndex = 0
      itemizeFieldView.characteristics[0].value = characteristicOptions0[0]
      itemizeFieldView.characteristics[1].value = characteristicOptions1[0]
      itemizeFieldView.characteristics[2].value = characteristicOptions2[0]
      saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
        let context = self.coreDataController.persistentContainer.viewContext
        let newItemizeField = ItemizedPurchaseCostsField(context: context)
        self.property.worksheet?.purchaseCosts?.addToItemizedPurchaseCosts(newItemizeField)
        self.savedItemizedPurchaseCostsField(newItemizeField,context: context)
        self.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
      return
    }
      topItem.title = "Edit Purchase Costs"
      itemizeFieldView.segmentedControls[0].selectedSegmentIndex = Int(itemizePurchaseCostsField.characteristic1)
      itemizeFieldView.segmentedControls[1].selectedSegmentIndex = Int(itemizePurchaseCostsField.characteristic2)
      itemizeFieldView.segmentedControls[2].selectedSegmentIndex = Int(itemizePurchaseCostsField.characteristic3)
      itemizeFieldView.characteristics[0].value = characteristicOptions0[Int(itemizePurchaseCostsField.characteristic1)]
      itemizeFieldView.characteristics[1].value = characteristicOptions1[Int(itemizePurchaseCostsField.characteristic2)]
      itemizeFieldView.characteristics[2].value = characteristicOptions2[Int(itemizePurchaseCostsField.characteristic3)]
      itemizeFieldView.nameTF.text = itemizePurchaseCostsField.name
      itemizeFieldView.amountTF.text = itemizePurchaseCostsField.characteristic1 == PurchaseCostsCharacteristic1.SetAmount.number ? itemizePurchaseCostsField.setAmount?.stringValue : itemizePurchaseCostsField.percentValue?.stringValue
      saveButton.rx.tap.subscribe(onNext:{[unowned self] Void in
        self.savedItemizedPurchaseCostsField(itemizePurchaseCostsField,context: self.coreDataController.persistentContainer.viewContext)
        self.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)

  }
  func savedItemizedRehabCostsField(_ field:ItemizedRehabCostsField,context:NSManagedObjectContext){
    if let name = self.itemizeFieldView.nameTF.text,!name.isEmpty{
      field.name = name
    }else{
      field.name = "New Costs"
    }
    let setAmount = NSDecimalNumber(string:self.itemizeFieldView.amountTF.text)
    if setAmount != NSDecimalNumber.notANumber{
      field.setAmount = setAmount
    }
    
    context.perform {
      do{
        try context.save()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ItemizeItemType.RehabCosts.savedNotification), object: nil)
      }catch{
        fatalError("Failure to save context: \(error)")
      }
    }
  }

  func savedItemizedPurchaseCostsField(_ field:ItemizedPurchaseCostsField,context:NSManagedObjectContext){
    field.characteristic1 = Int32(self.itemizeFieldView.segmentedControls[0].selectedSegmentIndex)
    field.characteristic2 = Int32(self.itemizeFieldView.segmentedControls[1].selectedSegmentIndex)
    field.characteristic3 = Int32(self.itemizeFieldView.segmentedControls[2].selectedSegmentIndex)
    if let name = self.itemizeFieldView.nameTF.text,!name.isEmpty{
      field.name = name
    }else{
      field.name = "New Costs"
    }
    if let amount = self.itemizeFieldView.amountTF.text{
      if self.itemizeFieldView.characteristics[0].value?.characteristic == .Percent{
          field.percentValue = NSDecimalNumber(string:amount).limitToRange(100, min: 0)
          field.isSetAmount = false
      }else if self.itemizeFieldView.characteristics[0].value?.characteristic == .SetAmount,NSDecimalNumber(string:amount) != NSDecimalNumber.notANumber{
        field.setAmount = NSDecimalNumber(string:amount)
      }
    }
    
    context.perform {
      do{
        try context.save()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ItemizeItemType.PurchaseCosts.savedNotification), object: nil)
      }catch{
        fatalError("Failure to save context: \(error)")
      }
    }
  }
  func savedItemizedHoldingCostsField(_ field:ItemizedHoldingCostsField,context:NSManagedObjectContext){
    field.characteristic1 = Int32(self.itemizeFieldView.segmentedControls[0].selectedSegmentIndex)
    field.characteristic2 = Int32(self.itemizeFieldView.segmentedControls[1].selectedSegmentIndex)
    if let name = self.itemizeFieldView.nameTF.text,!name.isEmpty{
      field.name = name
    }else{
      field.name = "New Costs"
    }
    if let amount = self.itemizeFieldView.amountTF.text{
      if self.itemizeFieldView.characteristics[0].value?.characteristic == .Percent{
        field.percentValue = NSDecimalNumber(string:amount).limitToRange(100, min: 0)
        field.isSetAmount = false
      }else if self.itemizeFieldView.characteristics[0].value?.characteristic == .SetAmount,NSDecimalNumber(string:amount) != NSDecimalNumber.notANumber{
        field.setAmount = NSDecimalNumber(string:amount)
      }
    }
    
    context.perform {
      do{
        try context.save()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ItemizeItemType.HoldingCosts.savedNotification), object: nil)
      }catch{
        fatalError("Failure to save context: \(error)")
      }
    }
  }
  func savedItemizedSellingCostsField(_ field:ItemizedSellingCostsField,context:NSManagedObjectContext){
    field.characteristic1 = Int32(self.itemizeFieldView.segmentedControls[0].selectedSegmentIndex)
    if let name = self.itemizeFieldView.nameTF.text,!name.isEmpty{
      field.name = name
    }else{
      field.name = "New Costs"
    }
    if let amount = self.itemizeFieldView.amountTF.text,!amount.isEmpty{
      if self.itemizeFieldView.characteristics[0].value?.characteristic == .Percent,NSDecimalNumber(string:amount) != NSDecimalNumber.notANumber{
        field.percentValue = NSDecimalNumber(string:amount).limitToRange(100, min: 0)
        field.isSetAmount = false
      }else if self.itemizeFieldView.characteristics[0].value?.characteristic == .SetAmount,NSDecimalNumber(string:amount) != NSDecimalNumber.notANumber{
        field.setAmount = NSDecimalNumber(string:amount)
      }
    }
    
    context.perform {
      do{
        try context.save()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ItemizeItemType.SellingCosts.savedNotification), object: nil)
      }catch{
        fatalError("Failure to save context: \(error)")
      }
    }
  }
  func savedItemizedIncomeField(_ field:ItemizedIncomeField,context:NSManagedObjectContext){
    field.characteristic1 = Int32(self.itemizeFieldView.segmentedControls[0].selectedSegmentIndex)
    if let name = self.itemizeFieldView.nameTF.text,!name.isEmpty{
      field.name = name
    }else{
      field.name = "New Income"
    }
    let setAmount = NSDecimalNumber(string: self.itemizeFieldView.amountTF.text)
    if setAmount != NSDecimalNumber.notANumber{
      field.setAmount = setAmount
    }
    
    
    context.perform {
      do{
        try context.save()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ItemizeItemType.Income.savedNotification), object: nil)
      }catch{
        fatalError("Failure to save context: \(error)")
      }
    }
  }
  func savedItemizedExpensesField(_ field:ItemizedExpensesField,context:NSManagedObjectContext){
    field.characteristic1 = Int32(self.itemizeFieldView.segmentedControls[0].selectedSegmentIndex)
    field.characteristic2 = Int32(self.itemizeFieldView.segmentedControls[1].selectedSegmentIndex)
    field.characteristic3 = Int32(self.itemizeFieldView.segmentedControls[2].selectedSegmentIndex)
    field.characteristic3 = Int32(self.itemizeFieldView.segmentedControls[3].selectedSegmentIndex)
    if let name = self.itemizeFieldView.nameTF.text,!name.isEmpty{
      field.name = name
    }else{
      field.name = "New Expense"
    }
    if let amount = self.itemizeFieldView.amountTF.text{
      if self.itemizeFieldView.characteristics[0].value?.characteristic == .Percent{
        let percent = NSDecimalNumber(string:amount)
        if percent != NSDecimalNumber.notANumber{
          field.percentValue = NSDecimalNumber(string:amount).limitToRange(100, min: 0)
        }
        field.isSetAmount = false
      }else if self.itemizeFieldView.characteristics[0].value?.characteristic == .SetAmount,NSDecimalNumber(string:amount) != NSDecimalNumber.notANumber{
        field.setAmount = NSDecimalNumber(string:amount)
      }
    }
    
    context.perform {
      do{
        try context.save()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ItemizeItemType.Expenses.savedNotification), object: nil)
      }catch{
        fatalError("Failure to save context: \(error)")
      }
    }
  }
}
