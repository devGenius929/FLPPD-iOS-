//
//  ItemizeViewController.swift
//  FLPPD
//
//  Created by PC on 5/25/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ItemizeViewController:UIViewController{
  fileprivate enum EditMode{
    case edit
    case move
    case delete
    case none
  }
  var coreDataController:CoreDataController!
  fileprivate let disposeBag = DisposeBag()
  fileprivate var editMode = EditMode.none
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(configureCell: {(_,_,_,_) in return UITableViewCell()})
  var itemizeItemType:ItemizeItemType = .PurchaseCosts
  var itemizeSwitch:UISwitch!
  private let keyboardToolbar = FormKeyboardToolbar()
  fileprivate let itemizeTableView = UITableView()
  fileprivate let itemizeData:Variable<[SectionOfCustomData]> = Variable([])
  fileprivate let itemized = Variable(false)
  fileprivate let showDelete = Variable(false)
  var property:Property!
  //MARK:Views
  let controlCell = ItemizeData(cell:ItemizeControlView(),height:81,collapsed:false,canEdit:false,enableMove:false,separatorInset:.zero)
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(itemizeTableView)
    itemizeTableView.pinToSuperView()
    itemizeTableView.rowHeight = 44
    itemizeTableView.tableFooterView = UIView()
    itemizeTableView.backgroundColor = UIColor.groupTableViewBackground
    itemizeTableView.delegate = self
    itemizeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemizeCell")
    switch itemizeItemType{
    case .PurchaseCosts:
      title = "Purchase Costs"
      getItemizedPurchaseCosts()
    case .RehabCosts:
      title = "Rehab Costs"
      getItemizedRehabCosts()
    case .HoldingCosts:
      title = "Holding Costs"
      getItemizedHoldingCosts()
    case .SellingCosts:
      title = "Selling Costs"
      getItemizedSellingCosts()
    case .Income:
      title = "Other Income"
      getItemizedIncome()
    case .Expenses:
      title = "Expenses"
      getItemizedExpenses()
    }
    //MARK:Datasource
    dataSource.canMoveRowAtIndexPath = { datasource,index in
      return self.editMode == .move ? true : false
    }
    
    dataSource.canEditRowAtIndexPath = {datasource, index in
      return self.itemizeData.value[0].items[index.row].canEdit
    }
    
    dataSource.configureCell = {datasource,tableview,indexpath,item in
      let cell = UITableViewCell()
      cell.selectionStyle = .none
      if item.collapsed {
        return cell
      }
      cell.separatorInset = item.separatorInset
      cell.contentView.addSubview(item.cell)
      item.cell.pinToSuperView()
      return cell
    }
    //MARK:Tableview
    itemizeData.asObservable().bind(to: itemizeTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    
    itemizeTableView.rx.itemDeleted.subscribe(onNext:{[unowned self](indexPath)->Void in
      let index = indexPath.row - 2
      self.itemizeData.value[0].items.remove(at: indexPath.row)
      switch self.itemizeItemType{
      case .PurchaseCosts:
        self.property.worksheet?.purchaseCosts?.removeFromItemizedPurchaseCosts(at: index)
        calculateItemizedPurchaseCostsTotal(self.property.worksheet!)
      case .RehabCosts:
        self.property.worksheet?.rehabCosts?.removeFromItemizedRehabCosts(at: index)
        self.getItemizedRehabCosts()
      case .HoldingCosts:
        (self.property.worksheet as? FlipWorksheet)?.holdingCosts?.removeFromItemizedHoldingCosts(at:index)
        calculateItemizeHoldingCostsTotal(self.property.worksheet as! FlipWorksheet)
      case .SellingCosts:
        (self.property.worksheet as? FlipWorksheet)?.sellingCosts?.removeFromItemizedSellingCosts(at:index)
        calculateItemizedSellingCostsTotal(self.property.worksheet as! FlipWorksheet)
      case .Income:
        (self.property.worksheet as? RentalWorksheet)?.income?.removeFromItemizedIncome(at: index)
        self.getItemizedIncome()
      case .Expenses:
        (self.property.worksheet as? RentalWorksheet)?.expenses?.removeFromItemizedExpenses(at: index)
        calculateItemizedExpensesTotal(self.property.worksheet as! RentalWorksheet)
      }
    }).disposed(by: disposeBag)
    
    itemizeTableView.rx.itemMoved.subscribe(onNext:{[unowned self](itemMovedEvent)->Void in
      let dstTableIndex = itemMovedEvent.destinationIndex.row
      let srcTableIndex = itemMovedEvent.sourceIndex.row
      let src = self.itemizeData.value[0].items[srcTableIndex]
      self.itemizeData.value[0].items.remove(at: srcTableIndex)
      self.itemizeData.value[0].items.insert(src, at: dstTableIndex)
      let srcIndex = srcTableIndex - 2
      let dstIndex = dstTableIndex - 2
      switch self.itemizeItemType{
      case .PurchaseCosts:
        let srcField = self.property.worksheet?.purchaseCosts?.itemizedPurchaseCosts?[srcIndex] as! ItemizedPurchaseCostsField
        self.property.worksheet?.purchaseCosts?.removeFromItemizedPurchaseCosts(at: srcIndex)
        self.property.worksheet?.purchaseCosts?.insertIntoItemizedPurchaseCosts(srcField, at: dstIndex)
        self.getItemizedPurchaseCosts()
      case .RehabCosts:
        let srcField = self.property.worksheet?.rehabCosts?.itemizedRehabCosts?[srcIndex] as! ItemizedRehabCostsField
        self.property.worksheet?.rehabCosts?.removeFromItemizedRehabCosts(at: srcIndex)
        self.property.worksheet?.rehabCosts?.insertIntoItemizedRehabCosts(srcField, at: dstIndex)
        self.getItemizedRehabCosts()
      case .HoldingCosts:
        let srcField = (self.property.worksheet as? FlipWorksheet)?.holdingCosts?.itemizedHoldingCosts?[srcIndex] as! ItemizedHoldingCostsField
        (self.property.worksheet as? FlipWorksheet)?.holdingCosts?.removeFromItemizedHoldingCosts(at: srcIndex)
        (self.property.worksheet as? FlipWorksheet)?.holdingCosts?.insertIntoItemizedHoldingCosts(srcField, at: dstIndex)
        self.getItemizedHoldingCosts()
      case .SellingCosts:
        let srcField = (self.property.worksheet as? FlipWorksheet)?.sellingCosts?.itemizedSellingCosts?[srcIndex] as! ItemizedSellingCostsField
        (self.property.worksheet as? FlipWorksheet)?.sellingCosts?.removeFromItemizedSellingCosts(at: srcIndex)
        (self.property.worksheet as? FlipWorksheet)?.sellingCosts?.insertIntoItemizedSellingCosts(srcField, at: dstIndex)
        self.getItemizedSellingCosts()
      case .Income:
        let srcField = (self.property.worksheet as? RentalWorksheet)?.income?.itemizedIncome?[srcIndex] as! ItemizedIncomeField
        (self.property.worksheet as? RentalWorksheet)?.income?.removeFromItemizedIncome(at: srcIndex)
        (self.property.worksheet as? RentalWorksheet)?.income?.insertIntoItemizedIncome(srcField, at: dstIndex)
        self.getItemizedIncome()
      case .Expenses:
        let srcField = (self.property.worksheet as? RentalWorksheet)?.expenses?.itemizedExpenses?[srcIndex] as! ItemizedExpensesField
        (self.property.worksheet as? RentalWorksheet)?.expenses?.removeFromItemizedExpenses(at: srcIndex)
        (self.property.worksheet as? RentalWorksheet)?.expenses?.insertIntoItemizedExpenses(srcField, at: dstIndex)
        self.getItemizedExpenses()
      }
    }).disposed(by: disposeBag)
    //MARK:Itemized switch
    itemized.asObservable().subscribe(onNext:{[unowned self](itemized)->Void in
      switch self.itemizeItemType{
      case .PurchaseCosts:
        self.property.worksheet?.purchaseCosts?.itemized = itemized
      case .RehabCosts:
        self.property.worksheet?.rehabCosts?.itemized = itemized
      case .HoldingCosts:
        (self.property.worksheet as! FlipWorksheet).holdingCosts?.itemized = itemized
      case .SellingCosts:
        (self.property.worksheet as! FlipWorksheet).sellingCosts?.itemized = itemized
      case .Income:
        (self.property.worksheet as! RentalWorksheet).income?.itemized = itemized
      case .Expenses:
        (self.property.worksheet as! RentalWorksheet).expenses?.itemized = itemized
      }
      if itemized {
        self.enableItemize()
      }else{
        self.itemizeTableView.setEditing(false, animated: false)
        self.disableItemize()
      }
    }).disposed(by: disposeBag)
    
    
    
    //MARK:Control buttons
    (controlCell.cell as! ItemizeControlView).deleteButton.rx.controlEvent(.touchUpInside).subscribe(onNext:{[unowned self] Void in
      if self.itemizeTableView.isEditing{
        self.itemizeTableView.setEditing(false, animated: true)
      }
      if self.editMode == .delete{
        self.editMode = .none
      }else{
        self.itemizeTableView.reloadSections([0], animationStyle: .none)
        self.editMode = .delete
        self.itemizeTableView.setEditing(true, animated: true)
      }
    }).disposed(by: disposeBag)
    
    (controlCell.cell as! ItemizeControlView).rearrangeButton.rx.controlEvent(.touchUpInside).subscribe(onNext:{[unowned self] Void in
      if self.itemizeTableView.isEditing{
        self.itemizeTableView.setEditing(false, animated: true)
      }
      if self.editMode == .move{
        self.editMode = .none
      }else{
        self.itemizeTableView.reloadSections([0], animationStyle: .none)
        self.editMode = .move
        self.itemizeTableView.setEditing(true, animated: true)
      }
    }).disposed(by: disposeBag)
    
    (controlCell.cell as! ItemizeControlView).editButton.rx.controlEvent(.touchUpInside).subscribe(onNext:{[unowned self] Void in
      if self.itemizeTableView.isEditing{
        self.itemizeTableView.setEditing(false, animated: true)
      }
      if self.editMode == .edit{
        self.editMode = .none
      }else{
        self.itemizeTableView.reloadSections([0], animationStyle: .none)
        self.editMode = .edit
        self.itemizeTableView.setEditing(true, animated: true)
      }
    }).disposed(by: disposeBag)
    
    (controlCell.cell as! ItemizeControlView).addButton.rx.controlEvent(.touchUpInside).subscribe(onNext:{[unowned self] Void in
      let vc = ItemizeFieldViewController()
      vc.itemizeFieldMode = .new
      vc.coreDataController = self.coreDataController
      vc.property = self.property
      vc.itemizeItemType = self.itemizeItemType
      self.present(vc, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(Notification.Name(ItemizeItemType.PurchaseCosts.savedNotification)).subscribe(onNext:{[unowned self] Void in
      self.getItemizedPurchaseCosts()
    }).disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(Notification.Name(ItemizeItemType.RehabCosts.savedNotification)).subscribe(onNext:{[unowned self] Void in
      self.getItemizedRehabCosts()
    }).disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(Notification.Name(ItemizeItemType.HoldingCosts.savedNotification)).subscribe(onNext:{[unowned self] Void in
      self.getItemizedHoldingCosts()
    }).disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(Notification.Name(ItemizeItemType.SellingCosts.savedNotification)).subscribe(onNext:{[unowned self] Void in
      self.getItemizedSellingCosts()
    }).disposed(by: disposeBag)
    NotificationCenter.default.rx.notification(Notification.Name(ItemizeItemType.Income.savedNotification)).subscribe(onNext:{[unowned self] Void in
      self.getItemizedIncome()
    }).disposed(by: disposeBag)
    NotificationCenter.default.rx.notification(Notification.Name(ItemizeItemType.Expenses.savedNotification)).subscribe(onNext:{[unowned self] Void in
      self.getItemizedExpenses()
    }).disposed(by: disposeBag)
    NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(onNext:{[unowned self](notification)->Void in
      guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else{
        return
      }
      let contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height + 18, 0)
      self.itemizeTableView.contentInset = contentInset
      self.itemizeTableView.scrollIndicatorInsets = contentInset
    }).disposed(by: disposeBag)
    //Handle keyboard hide
    NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext:{[unowned self](notification)->Void in
      let contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
      self.itemizeTableView.contentInset = contentInset
      self.itemizeTableView.scrollIndicatorInsets = contentInset
    }).disposed(by: disposeBag)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.coreDataController.saveMainContext()
  }
  
  func getItemizedRehabCosts(){
    let data = setupRehabCostsItemizedView()
    var sectionData = data
    sectionData.append(controlCell)
    itemizeData.value = [SectionOfCustomData(header: "", items:sectionData)]
    itemized.value = (property.worksheet?.rehabCosts?.itemized)!
  }
  func getItemizedPurchaseCosts(){
    let data = setupPurchaseCostsItemizedView()
    var sectionData = data
    sectionData.append(controlCell)
    itemizeData.value = [SectionOfCustomData(header: "", items:sectionData)]
    itemized.value = (property.worksheet?.purchaseCosts?.itemized)!
  }
  func getItemizedHoldingCosts(){
    let data = setupHoldingCostsItemizedView()
    var sectionData = data
    sectionData.append(controlCell)
    itemizeData.value = [SectionOfCustomData(header: "", items:sectionData)]
    itemized.value = ((property.worksheet as? FlipWorksheet)?.holdingCosts?.itemized)!
  }
  func getItemizedSellingCosts(){
    let data = setupSellingCostsItemizedView()
    var sectionData = data
    sectionData.append(controlCell)
    itemizeData.value = [SectionOfCustomData(header: "", items:sectionData)]
    itemized.value = ((property.worksheet as? FlipWorksheet)?.sellingCosts?.itemized)!
  }
  func getItemizedIncome(){
    let data = setupIncomeItemizedView()
    var sectionData = data
    sectionData.append(controlCell)
    itemizeData.value = [SectionOfCustomData(header: "", items:sectionData)]
    itemized.value = ((property.worksheet as? RentalWorksheet)?.income?.itemized)!
  }
  func getItemizedExpenses(){
    let data = setupExpensesItemizedView()
    var sectionData = data
    sectionData.append(controlCell)
    itemizeData.value = [SectionOfCustomData(header: "", items:sectionData)]
    itemized.value = ((property.worksheet as? RentalWorksheet)?.expenses?.itemized)!
  }
  func setupExpensesItemizedView()->[ItemizeData]{
    var returnData = setupItemizedViewGeneric()
    guard let worksheet = property.worksheet as? RentalWorksheet else{
      return returnData
    }
    itemizeSwitch.isOn = (worksheet.expenses?.itemized)!
    itemizeSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.itemized.value = isOn
    }).disposed(by: disposeBag)
    let totalView = returnData[0].cell as! StandardFormFieldWithFloatingText
    let itemizeTotalView = returnData[2].cell as! StandardFormFieldWithFloatingText
    totalView.rightTextField.placeholder = "% of Rent"
    totalView.textFieldValueType.value = .Percent
    worksheet.expenses?.rx.observe(NSDecimalNumber.self, "total").subscribe(onNext:{(total)->Void in
      guard let total = total else{
        return
      }
      totalView.rightTextField.text = total.stringValue
    }).disposed(by: disposeBag)
    bindWorksheetDecimalAttribute(worksheet,keyPath:"expenses.total",textfield:totalView.rightTextField,minVal:0,maxVal:100,disposeBag:disposeBag)
    //create itemized total cell
    itemizeTotalView.rightTextField.placeholder = "$ Per Month"
    worksheet.expenses?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{(value)->Void in
      itemizeTotalView.rightTextField.text = value!.decimalFormat()
    }).disposed(by: disposeBag)
    
    guard let fields = worksheet.expenses?.itemizedExpenses else{
      return returnData
    }
    var textfields:[UITextField] = []
    for field in fields.array{
      guard let field = field as? ItemizedExpensesField else{
        break
      }
      let view = StandardFormFieldWithFloatingText()
      textfields.append(view.rightTextField)
      view.leftLabel.text = field.name
      var placeholder = String()
      if field.characteristic1 == ExpensesCharacteristic1.SetAmount.number {
        field.rx.observe(NSDecimalNumber.self, "setAmount").subscribe(onNext:{(value)->Void in
          calculateItemizedExpensesTotal(worksheet)
        }).disposed(by: disposeBag)
        placeholder += ExpensesCharacteristic1.SetAmount.characteristic.placeHolder
        placeholder += field.characteristic4 == ExpensesCharacteristic4.PerMonth.number ? " "+ExpensesCharacteristic4.PerMonth.characteristic.placeHolder : " "+ExpensesCharacteristic4.PerYear.characteristic.placeHolder
        view.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
          let setAmount = NSDecimalNumber(string: view.rightTextField.text)
          guard setAmount != NSDecimalNumber.notANumber else{
            field.setAmount = NSDecimalNumber.zero
            view.rightTextField.text = "0"
            return
          } 
          field.setAmount = setAmount
          view.rightTextField.text = setAmount.decimalFormat()
        }).disposed(by: disposeBag)
      }else{
        field.rx.observe(NSDecimalNumber.self, "percentValue").subscribe(onNext:{(value)->Void in
          calculateItemizedExpensesTotal(worksheet)
        }).disposed(by: disposeBag)
        placeholder += ExpensesCharacteristic1.Percent.characteristic.placeHolder
        if field.characteristic2 == ExpensesCharacteristic2.OfRent.number{
          placeholder += " "+ExpensesCharacteristic2.OfRent.characteristic.placeHolder
          placeholder += field.characteristic3 == ExpensesCharacteristic3.WithoutVacancy.number ? " "+ExpensesCharacteristic3.WithoutVacancy.characteristic.placeHolder : " "+ExpensesCharacteristic3.WithVacancy.characteristic.placeHolder
        }else{
          placeholder += " "+ExpensesCharacteristic2.OfPrice.characteristic.placeHolder + " "+Characteristic.PerYear.placeHolder
        }
        view.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
          guard let text = view.rightTextField.text else{
            field.percentValue = NSDecimalNumber.zero
            view.rightTextField.text = "0"
            return
          }
          let percent = NSDecimalNumber(string:text).limitToRange(100, min: 0)
          field.percentValue = percent
          view.rightTextField.text = percent.stringValue
        }).disposed(by: disposeBag)
      }
      view.rightTextField.placeholder = placeholder
     if field.characteristic1 == PurchaseCostsCharacteristic1.SetAmount.number{
        view.textFieldValueType.value = .SetAmount
        view.rightTextField.text = field.setAmount?.decimalFormat()
      }else{
        view.textFieldValueType.value = .Percent
        view.rightTextField.text = field.percentValue?.stringValue
      }
      view.rightTextField.inputAccessoryView = keyboardToolbar
      view.rightTextField.rx.controlEvent([.editingDidBegin]).subscribe(onNext:{[unowned self] Void in
        if let index = textfields.index(of: view.rightTextField){
          self.keyboardToolbar.nextButton.isEnabled = index == textfields.count - 1 ? false : true
          self.keyboardToolbar.previousButton.isEnabled = index == 0 ? false : true
        }
      }).disposed(by: disposeBag)
      let itemizeItem = ItemizeData(cell: view, height: 44, collapsed: false,canEdit:true,enableMove:false,separatorInset:UIEdgeInsets.defaultInset)
      returnData.insert(itemizeItem, at: returnData.count - 1)
    }
    setupKeyboardToolbar(textfields)
    return returnData
  }
  func setupIncomeItemizedView()->[ItemizeData]{
    var returnData = setupItemizedViewGeneric()
    guard let worksheet = property.worksheet as? RentalWorksheet else{
      return returnData
    }
    itemizeSwitch.isOn = (worksheet.income?.itemized)!
    itemizeSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.itemized.value = isOn
    }).disposed(by: disposeBag)
    let totalView = returnData[0].cell as! StandardFormFieldWithFloatingText
    let itemizeTotalView = returnData[2].cell as! StandardFormFieldWithFloatingText
    totalView.rightTextField.placeholder = "$ Per Month"
    totalView.textFieldValueType.value = .SetAmount
    worksheet.income?.rx.observe(NSDecimalNumber.self, "total").subscribe(onNext:{(total)->Void in
      guard let total = total else{
        return
      }
      totalView.rightTextField.text = total.decimalFormat()
    }).disposed(by: disposeBag)
    bindWorksheetDecimalAttribute(worksheet, keyPath: "income.total", textfield: totalView.rightTextField, minVal: 0, maxVal: nil, disposeBag: disposeBag)
    
    //create itemized total cell
    itemizeTotalView.rightTextField.placeholder = "$ Per Month"
    worksheet.income?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{(value)->Void in
      itemizeTotalView.rightTextField.text = value!.decimalFormat()
    }).disposed(by: disposeBag)
    
    guard let fields = worksheet.income?.itemizedIncome else{
      return returnData
    }
    var textfields:[UITextField] = []
    for field in fields.array{
      guard let field = field as? ItemizedIncomeField else{
        break
      }
      let view = StandardFormFieldWithFloatingText()
      textfields.append(view.rightTextField)
      view.leftLabel.text = field.name
      let placeholder = field.characteristic1 == IncomeCharacteristic1.PerMonth.number ? "$ "+IncomeCharacteristic1.PerMonth.characteristic.placeHolder : "$ " + IncomeCharacteristic1.PerYear.characteristic.placeHolder
      view.rightTextField.text = field.setAmount?.decimalFormat()
      view.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
        let setAmount = NSDecimalNumber(string: view.rightTextField.text)
        guard setAmount != NSDecimalNumber.notANumber else{
          field.setAmount = NSDecimalNumber.zero
          view.rightTextField.text = "0"
          return
        }
        field.setAmount = setAmount
        view.rightTextField.text = setAmount.decimalFormat()
      }).disposed(by: disposeBag)
      field.rx.observe(NSDecimalNumber.self, "setAmount").subscribe(onNext:{(value)->Void in
        var total = NSDecimalNumber.zero
        for field in fields.array{
          guard let field = field as? ItemizedIncomeField else{
            continue
          }
          total = field.characteristic1 == IncomeCharacteristic1.PerMonth.number ? total.adding(field.setAmount!) : total.adding(field.setAmount!.dividingBy12())
        }
        worksheet.income?.itemizedTotal = total
      }).disposed(by: disposeBag)

      view.rightTextField.placeholder = placeholder
      view.textFieldValueType.value = .SetAmount
      view.rightTextField.inputAccessoryView = keyboardToolbar
      view.rightTextField.rx.controlEvent([.editingDidBegin]).subscribe(onNext:{[unowned self] Void in
        if let index = textfields.index(of: view.rightTextField){
          self.keyboardToolbar.nextButton.isEnabled = index == textfields.count - 1 ? false : true
          self.keyboardToolbar.previousButton.isEnabled = index == 0 ? false : true
        }
      }).disposed(by: disposeBag)
      let itemizeItem = ItemizeData(cell: view, height: 44, collapsed: false,canEdit:true,enableMove:false,separatorInset:UIEdgeInsets.defaultInset)
      returnData.insert(itemizeItem, at: returnData.count - 1)
    }
    setupKeyboardToolbar(textfields)
    return returnData
  }
  func setupSellingCostsItemizedView()->[ItemizeData]{
    var returnData = setupItemizedViewGeneric()
    guard let worksheet = property.worksheet as? FlipWorksheet else{
      return returnData
    }
    itemizeSwitch.isOn = (worksheet.sellingCosts?.itemized)!
    itemizeSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.itemized.value = isOn
    }).disposed(by: disposeBag)
    let totalView = returnData[0].cell as! StandardFormFieldWithFloatingText
    let itemizeTotalView = returnData[2].cell as! StandardFormFieldWithFloatingText
    totalView.rightTextField.placeholder = "% of Price"
    totalView.textFieldValueType.value = .Percent
    worksheet.sellingCosts?.rx.observe(NSDecimalNumber.self, "total").subscribe(onNext:{(total)->Void in
      guard let total = total else{
        return
      }
      totalView.rightTextField.text = total.decimalFormat()
    }).disposed(by: disposeBag)
    totalView.textFieldValueType.value = .SetAmount
    totalView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
      guard let text = totalView.rightTextField.text else{
        return
      }
      let percent = NSDecimalNumber(string:text).limitToRange(100, min: 0)
      worksheet.sellingCosts?.total = percent
      totalView.rightTextField.text = percent.stringValue
    }).disposed(by: disposeBag)
    
    //create itemized total cell
    itemizeTotalView.rightTextField.placeholder = "$"
    worksheet.sellingCosts?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{(value)->Void in
      itemizeTotalView.rightTextField.text = value!.decimalFormat()
    }).disposed(by: disposeBag)
    
    guard let fields = worksheet.sellingCosts?.itemizedSellingCosts else{
      return returnData
    }
    var textfields:[UITextField] = []
    for field in fields.array{
      guard let field = field as? ItemizedSellingCostsField else{
        break
      }
      let view = StandardFormFieldWithFloatingText()
      textfields.append(view.rightTextField)
      view.leftLabel.text = field.name
      var placeholder = String()
      if field.characteristic1 == SellingCostsCharacteristic1.SetAmount.number {
        placeholder += SellingCostsCharacteristic1.SetAmount.characteristic.placeHolder
        view.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
          let setAmount = NSDecimalNumber(string: view.rightTextField.text)
          guard setAmount != NSDecimalNumber.notANumber else{
            field.setAmount = NSDecimalNumber.zero
            view.rightTextField.text = "0"
            return
          }
          field.setAmount = setAmount
          view.rightTextField.text = setAmount.stringValue
        }).disposed(by: disposeBag)
        
        field.rx.observe(NSDecimalNumber.self, "setAmount").subscribe(onNext:{(value)->Void in
          calculateItemizedSellingCostsTotal(worksheet)
        }).disposed(by: disposeBag)
      }else{
        view.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
          guard let text = view.rightTextField.text else{
            return
          }
          let percent = NSDecimalNumber(string:text).limitToRange(100, min: 0)
          field.percentValue = percent
          view.rightTextField.text = percent.stringValue
        }).disposed(by: disposeBag)
        field.rx.observe(NSDecimalNumber.self, "percentValue").subscribe(onNext:{(value)->Void in
          calculateItemizedSellingCostsTotal(worksheet)
        }).disposed(by: disposeBag)
        placeholder += SellingCostsCharacteristic1.Percent.characteristic.placeHolder + " " + Characteristic.OfPrice.placeHolder
      }
      view.rightTextField.placeholder = placeholder
      if field.characteristic1 == SellingCostsCharacteristic1.SetAmount.number{
        view.textFieldValueType.value = SellingCostsCharacteristic1.SetAmount.keyboardType
        view.rightTextField.text = field.setAmount?.stringValue
      }else{
        view.textFieldValueType.value = SellingCostsCharacteristic1.Percent.keyboardType
        view.rightTextField.text = field.percentValue?.stringValue
      }
      view.rightTextField.inputAccessoryView = keyboardToolbar
      view.rightTextField.rx.controlEvent([.editingDidBegin]).subscribe(onNext:{[unowned self] Void in
        if let index = textfields.index(of: view.rightTextField){
          self.keyboardToolbar.nextButton.isEnabled = index == textfields.count - 1 ? false : true
          self.keyboardToolbar.previousButton.isEnabled = index == 0 ? false : true
        }
      }).disposed(by: disposeBag)
      let itemizeItem = ItemizeData(cell: view, height: 44, collapsed: false,canEdit:true,enableMove:false,separatorInset:UIEdgeInsets.defaultInset)
      returnData.insert(itemizeItem, at: returnData.count - 1)
    }
    setupKeyboardToolbar(textfields)
    return returnData
  }
  func setupHoldingCostsItemizedView()->[ItemizeData]{
    var returnData = setupItemizedViewGeneric()
    guard let worksheet = property.worksheet as? FlipWorksheet else{
      return returnData
    }
    itemizeSwitch.isOn = (worksheet.holdingCosts?.itemized)!
    itemizeSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.itemized.value = isOn
    }).disposed(by: disposeBag)
    let totalView = returnData[0].cell as! StandardFormFieldWithFloatingText
    let itemizeTotalView = returnData[2].cell as! StandardFormFieldWithFloatingText
    totalView.rightTextField.placeholder = "$ Per Month"
    worksheet.holdingCosts?.rx.observe(NSDecimalNumber.self, "total").subscribe(onNext:{(total)->Void in
      guard let total = total else{
        return
      }
      totalView.rightTextField.text = total.decimalFormat()
    }).disposed(by: disposeBag)
    totalView.textFieldValueType.value = .SetAmount
    bindWorksheetDecimalAttribute(worksheet, keyPath: "holdingCosts.total", textfield: totalView.rightTextField, minVal: 0, maxVal: nil, disposeBag: disposeBag)
    
    //create itemized total cell
    itemizeTotalView.rightTextField.placeholder = "$ Per Month"
    worksheet.holdingCosts?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{(value)->Void in
      itemizeTotalView.rightTextField.text = value!.decimalFormat()
    }).disposed(by: disposeBag)
    
    guard let fields = worksheet.holdingCosts?.itemizedHoldingCosts else{
      return returnData
    }
    var textfields:[UITextField] = []
    for field in fields.array{
      guard let field = field as? ItemizedHoldingCostsField else{
        break
      }
      let view = StandardFormFieldWithFloatingText()
      textfields.append(view.rightTextField)
      view.leftLabel.text = field.name
      var placeholder = String()
      if field.characteristic1 == HoldingCostsCharacteristic1.SetAmount.number {
        placeholder += HoldingCostsCharacteristic1.SetAmount.characteristic.placeHolder
        placeholder += field.characteristic2 == HoldingCostsCharacteristic2.PerMonth.number ? " "+HoldingCostsCharacteristic2.PerMonth.characteristic.placeHolder : " "+HoldingCostsCharacteristic2.PerYear.characteristic.placeHolder
        view.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
          let setAmount = NSDecimalNumber(string: view.rightTextField.text)
          guard setAmount != NSDecimalNumber.notANumber else{
            field.setAmount = NSDecimalNumber.zero
            view.rightTextField.text = "0"
            return
          }
          field.setAmount = setAmount
          view.rightTextField.text = setAmount.decimalFormat()
        }).disposed(by: disposeBag)
          
        field.rx.observe(NSDecimalNumber.self, "setAmount").subscribe(onNext:{(value)->Void in
          calculateItemizeHoldingCostsTotal(worksheet)
        }).disposed(by: disposeBag)
      }else{
        field.rx.observe(NSDecimalNumber.self, "percentValue").subscribe(onNext:{(value)->Void in
          calculateItemizeHoldingCostsTotal(worksheet)
        }).disposed(by: disposeBag)
          view.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
            guard let text = view.rightTextField.text else{
              field.percentValue = NSDecimalNumber.zero
              view.rightTextField.text = "0"
              return
            }
            let percent = NSDecimalNumber(string:text).limitToRange(100, min: 0)
            field.percentValue = percent
            view.rightTextField.text = percent.stringValue
          }).disposed(by: disposeBag)
          placeholder += HoldingCostsCharacteristic1.Percent.characteristic.placeHolder + " " + Characteristic.OfPrice.placeHolder + " "+Characteristic.PerYear.placeHolder
        }
      
        view.rightTextField.placeholder = placeholder
        if field.characteristic1 == HoldingCostsCharacteristic1.SetAmount.number{
          view.textFieldValueType.value = HoldingCostsCharacteristic1.SetAmount.keyboardType
          view.rightTextField.text = field.setAmount?.stringValue
        }else{
          view.textFieldValueType.value = HoldingCostsCharacteristic1.Percent.keyboardType
          view.rightTextField.text = field.percentValue?.stringValue
        }
        view.rightTextField.inputAccessoryView = keyboardToolbar
        view.rightTextField.rx.controlEvent([.editingDidBegin]).subscribe(onNext:{[unowned self] Void in
          if let index = textfields.index(of: view.rightTextField){
            self.keyboardToolbar.nextButton.isEnabled = index == textfields.count - 1 ? false : true
            self.keyboardToolbar.previousButton.isEnabled = index == 0 ? false : true
          }
        }).disposed(by: disposeBag)
        let itemizeItem = ItemizeData(cell: view, height: 44, collapsed: false,canEdit:true,enableMove:false,separatorInset:UIEdgeInsets.defaultInset)
        returnData.insert(itemizeItem, at: returnData.count - 1)
      }
        setupKeyboardToolbar(textfields)
    return returnData
  }

  func setupRehabCostsItemizedView()->[ItemizeData]{
    var returnData = setupItemizedViewGeneric()
    itemizeSwitch.isOn = (property.worksheet?.rehabCosts?.itemized)!
    itemizeSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.itemized.value = isOn
    }).disposed(by: disposeBag)
    let totalView = returnData[0].cell as! StandardFormFieldWithFloatingText
    let itemizeTotalView = returnData[2].cell as! StandardFormFieldWithFloatingText
    totalView.rightTextField.placeholder = "$"
    property.worksheet?.rehabCosts?.rx.observe(NSDecimalNumber.self, "total").subscribe(onNext:{(total)->Void in
      guard let total = total else{
        return
      }
      totalView.rightTextField.text = total.decimalFormat()
    }).disposed(by: disposeBag)
    totalView.textFieldValueType.value = .SetAmount
    bindWorksheetDecimalAttribute(property.worksheet!, keyPath: "rehabCosts.total", textfield: totalView.rightTextField, minVal: 0, maxVal: nil, disposeBag: disposeBag)

    //create itemized total cell
    itemizeTotalView.rightTextField.placeholder = "$"
    property.worksheet?.rehabCosts?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{(value)->Void in
      itemizeTotalView.rightTextField.text = value!.decimalFormat()
    }).disposed(by: disposeBag)
    
    guard let fields = property.worksheet?.rehabCosts?.itemizedRehabCosts else{
      return returnData
    }
    var textfields:[UITextField] = []
    for field in fields.array{
      guard let field = field as? ItemizedRehabCostsField else{
        break
      }
      let view = StandardFormFieldWithFloatingText()
      textfields.append(view.rightTextField)
      view.leftLabel.text = field.name
      view.rightTextField.placeholder = "$"
      view.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{(text)->Void in
        let setAmount = NSDecimalNumber(string:view.rightTextField.text)
        guard setAmount != NSDecimalNumber.notANumber else{
          field.setAmount = NSDecimalNumber.zero
          view.rightTextField.text = "0"
          return
        }
          field.setAmount = setAmount
          view.rightTextField.text = setAmount.decimalFormat()
        }).disposed(by: disposeBag)
        
      field.rx.observe(NSDecimalNumber.self, "setAmount").subscribe(onNext:{[unowned self](value)->Void in
          var total = NSDecimalNumber.zero
          for field in fields.array{
            guard let field = field as? ItemizedRehabCostsField else{
              continue
            }
          total = total.adding(field.setAmount!)
          }
          self.property.worksheet?.rehabCosts?.itemizedTotal = total
        }).disposed(by: disposeBag)
      
      view.textFieldValueType.value = .SetAmount
      view.rightTextField.text = field.setAmount?.stringValue
      view.rightTextField.inputAccessoryView = keyboardToolbar
      view.rightTextField.rx.controlEvent([.editingDidBegin]).subscribe(onNext:{[unowned self] Void in
        if let index = textfields.index(of: view.rightTextField){
          self.keyboardToolbar.nextButton.isEnabled = index == textfields.count - 1 ? false : true
          self.keyboardToolbar.previousButton.isEnabled = index == 0 ? false : true
        }
      }).disposed(by: disposeBag)
      let itemizeItem = ItemizeData(cell: view, height: 44, collapsed: false,canEdit:true,enableMove:false,separatorInset:UIEdgeInsets.defaultInset)
      returnData.insert(itemizeItem, at: returnData.count - 1)
    }
    setupKeyboardToolbar(textfields)
    return returnData
  }
  
  func setupPurchaseCostsItemizedView()->[ItemizeData]{
    var returnData = setupItemizedViewGeneric()
    itemizeSwitch.isOn = (property.worksheet?.purchaseCosts?.itemized)!
    itemizeSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.itemized.value = isOn
    }).disposed(by: disposeBag)
    let totalView = returnData[0].cell as! StandardFormFieldWithFloatingText
    let itemizeTotalView = returnData[2].cell as! StandardFormFieldWithFloatingText
    totalView.rightTextField.placeholder = "% of Price"
    totalView.textFieldValueType.value = .Percent
    property.worksheet?.purchaseCosts?.rx.observe(NSDecimalNumber.self, "total").subscribe(onNext:{(total)->Void in
      guard let total = total else{
        return
      }
      totalView.rightTextField.text = total.stringValue
    }).disposed(by: disposeBag)
    bindWorksheetDecimalAttribute(property.worksheet!, keyPath: "purchaseCosts.total", textfield: totalView.rightTextField, minVal: 0, maxVal: 100, disposeBag: disposeBag)
    
    //create itemized total cell
    itemizeTotalView.rightTextField.placeholder = "$"
    property.worksheet?.purchaseCosts?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{(value)->Void in
      itemizeTotalView.rightTextField.text = value!.decimalFormat()
    }).disposed(by: disposeBag)
  
    guard let fields = property.worksheet?.purchaseCosts?.itemizedPurchaseCosts else{
      return returnData
    }
    var textfields:[UITextField] = []
    for field in fields.array{
      guard let field = field as? ItemizedPurchaseCostsField else{
        break
      }
      let view = StandardFormFieldWithFloatingText()
      textfields.append(view.rightTextField)
      view.leftLabel.text = field.name
      var placeholder = String()
      if field.characteristic1 == PurchaseCostsCharacteristic1.SetAmount.number {
        placeholder += PurchaseCostsCharacteristic1.SetAmount.characteristic.placeHolder
        view.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
          let setAmount = NSDecimalNumber(string: view.rightTextField.text)
          guard setAmount != NSDecimalNumber.notANumber else{
            field.setAmount = NSDecimalNumber.zero
            view.rightTextField.text = "0"
            return
          }
          field.setAmount = setAmount
          view.rightTextField.text = setAmount.decimalFormat()
        }).disposed(by: disposeBag)
        
        field.rx.observe(NSDecimalNumber.self, "setAmount").subscribe(onNext:{[unowned self] Void in
            calculateItemizedPurchaseCostsTotal(self.property.worksheet!)
        }).disposed(by: disposeBag)
      }else{
        field.rx.observe(NSDecimalNumber.self, "percentValue").subscribe(onNext:{[unowned self] Void in
          calculateItemizedPurchaseCostsTotal(self.property.worksheet!)
        }).disposed(by: disposeBag)
        view.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
          guard let text = view.rightTextField.text else{
            field.percentValue = NSDecimalNumber.zero
            view.rightTextField.text = "0"
            return
          }
          field.percentValue = NSDecimalNumber(string:text).limitToRange(100, min: 0)
          view.rightTextField.text = field.percentValue?.stringValue
        }).disposed(by: disposeBag)
        placeholder += PurchaseCostsCharacteristic1.Percent.characteristic.placeHolder
        placeholder += field.characteristic2 == PurchaseCostsCharacteristic2.OfPrice.number ? " "+PurchaseCostsCharacteristic2.OfPrice.characteristic.placeHolder : " "+PurchaseCostsCharacteristic2.OfLoan.characteristic.placeHolder
      }
      placeholder += field.characteristic3 == PurchaseCostsCharacteristic3.PayUpfront.number ? " "+PurchaseCostsCharacteristic3.PayUpfront.characteristic.placeHolder : " "+PurchaseCostsCharacteristic3.WrapIntoLoan.characteristic.placeHolder
      view.rightTextField.placeholder = placeholder
      if field.characteristic1 == PurchaseCostsCharacteristic1.SetAmount.number{
        view.textFieldValueType.value = .SetAmount
        view.rightTextField.text = field.setAmount?.stringValue
      }else{
        view.textFieldValueType.value = .Percent
        view.rightTextField.text = field.percentValue?.stringValue
      }
      view.rightTextField.inputAccessoryView = keyboardToolbar
      view.rightTextField.rx.controlEvent([.editingDidBegin]).subscribe(onNext:{[unowned self] Void in
        if let index = textfields.index(of: view.rightTextField){
          self.keyboardToolbar.nextButton.isEnabled = index == textfields.count - 1 ? false : true
          self.keyboardToolbar.previousButton.isEnabled = index == 0 ? false : true
        }
      }).disposed(by: disposeBag)
      let itemizeItem = ItemizeData(cell: view, height: 44, collapsed: false,canEdit:true,enableMove:false,separatorInset:UIEdgeInsets.defaultInset)
      returnData.insert(itemizeItem, at: returnData.count - 1)
    }
    setupKeyboardToolbar(textfields)
    return returnData
  }
  
  func setupKeyboardToolbar(_ textfields:[UITextField]){
    keyboardToolbar.doneButton.rx.tap.subscribe(onNext:{Void in
      self.itemizeTableView.endEditing(false)
    }).disposed(by: disposeBag)
    keyboardToolbar.nextButton.rx.tap.subscribe(onNext:{Void in
      var nextTF:UITextField?
      for tf in textfields{
        if tf.isFirstResponder,let index = textfields.index(of: tf),index != textfields.count - 1{
          nextTF = textfields[index + 1]
          break
        }
      }
      nextTF?.becomeFirstResponder()
    }).disposed(by: disposeBag)
    keyboardToolbar.previousButton.rx.tap.subscribe(onNext:{Void in
      var prevTF:UITextField?
      var currentTF:UITextField?
      
      for tf in textfields{
        if tf.isFirstResponder,let index = textfields.index(of: tf),index != 0{
          prevTF = textfields[index - 1]
          currentTF = tf
          break
        }
      }
      guard let unwrappedPrevTF = prevTF else{
        return
      }
      
      guard let cell = currentTF?.superview?.superview?.superview as? UITableViewCell, let prevIndexPath = self.itemizeTableView.indexPath(for: cell) else{
        return
      }
      let indexPath = IndexPath(row: prevIndexPath.row - 1, section: prevIndexPath.section)
      self.itemizeTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
      unwrappedPrevTF.becomeFirstResponder()
    }).disposed(by: disposeBag)
  }
  
  func setupItemizedViewGeneric()->[ItemizeData]{
    //create total cell
    let totalTFInputToolbar = FormKeyboardToolbar()
    totalTFInputToolbar.nextButton.isEnabled = false
    totalTFInputToolbar.previousButton.isEnabled = false
    let totalView = StandardFormFieldWithFloatingText()
    totalView.rightTextField.inputAccessoryView = totalTFInputToolbar
    totalTFInputToolbar.doneButton.rx.tap.subscribe(onNext:{Void in
      totalView.rightTextField.resignFirstResponder()
    }).disposed(by: disposeBag)
    totalView.leftLabel.text = "Total"
    let totalCell = ItemizeData(cell: totalView, height: 44,collapsed:false,canEdit:false,enableMove:false,separatorInset:.defaultInset)
    //create itemize view
    let itemizeView = StandardFormFieldWithSwitch()
    itemizeView.leftLabel.text = "Itemize"
    itemizeSwitch = itemizeView.rightSwitch
    let itemizeCell = ItemizeData(cell: itemizeView, height: 44,collapsed:false,canEdit:false,enableMove:false,separatorInset:.zero)
    //create itemize total cell
    let itemizeTotalView = StandardFormFieldWithFloatingText()
    itemizeTotalView.isUserInteractionEnabled = false
    itemizeTotalView.leftLabel.text = "Total"
    itemizeTotalView.leftLabel.textColor = UIColor.darkgreen
    itemizeTotalView.rightTextField.textColor = UIColor.darkgreen
    let itemizeTotalCell = ItemizeData(cell: itemizeTotalView, height: 44,collapsed:false,canEdit:false,enableMove:false,separatorInset:.defaultInset)
    return [totalCell,itemizeCell,itemizeTotalCell]
  }
  func disableItemize(){
    for index in 0..<self.itemizeData.value.first!.items.count{
      self.itemizeData.value[0].items[index].collapsed = index != 0 && index != 1 ? true : false
    }
  }
  
  func enableItemize(){
    for index in 0..<self.itemizeData.value.first!.items.count{
      self.itemizeData.value[0].items[index].collapsed = index != 0 ? false : true
    }
  }
}

extension ItemizeViewController:UITableViewDelegate{
  func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
    let maxIndex = itemizeData.value[0].items.count - 2
    if proposedDestinationIndexPath.row >= maxIndex{
      return IndexPath(row: maxIndex - 1, section: proposedDestinationIndexPath.section)
    }
    else if proposedDestinationIndexPath.row <= 1{
      return IndexPath(row: 2, section: proposedDestinationIndexPath.section)
    }
    return proposedDestinationIndexPath
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.itemizeData.value[0].items[indexPath.row].collapsed ? 0 : self.itemizeData.value[0].items[indexPath.row].height
  }

  func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    //do this so the cell doesn't indent on the left side when we show our editingaccessoryview
    return editMode == .delete ? true : false
  }
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    let cell = self.itemizeTableView.cellForRow(at: indexPath)
    cell?.editingAccessoryView = nil
    switch editMode{
    case .delete:
      return .delete
    case .edit:
      let editButton = UIButton()
      editButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
      editButton.setImage(UIImage(named:"pencil"), for: .normal)
      editButton.rx.tap.subscribe(onNext:{[unowned self] Void in
        let vc = ItemizeFieldViewController()
        let index = indexPath.row - 2
        switch self.itemizeItemType{
        case .PurchaseCosts:
          vc.itemizeField = self.property.worksheet?.purchaseCosts?.itemizedPurchaseCosts?.array[index] as? ItemizeField
        case .RehabCosts:
          vc.itemizeField = self.property.worksheet?.rehabCosts?.itemizedRehabCosts?.array[index] as? ItemizeField
        case .HoldingCosts:
          vc.itemizeField = (self.property.worksheet as? FlipWorksheet)?.holdingCosts?.itemizedHoldingCosts?.array[index] as? ItemizeField
        case .SellingCosts:
          vc.itemizeField = (self.property.worksheet as? FlipWorksheet)?.sellingCosts?.itemizedSellingCosts?.array[index] as? ItemizeField
        case .Income:
          vc.itemizeField = (self.property.worksheet as? RentalWorksheet)?.income?.itemizedIncome?.array[index] as? ItemizeField
        case .Expenses:
          vc.itemizeField = (self.property.worksheet as? RentalWorksheet)?.expenses?.itemizedExpenses?.array[index] as? ItemizeField
        }
        vc.itemizeFieldMode = .edit
        vc.coreDataController = self.coreDataController
        vc.itemizeItemType = self.itemizeItemType
        self.present(vc, animated: true, completion: nil)
      }).disposed(by: disposeBag)
      cell?.editingAccessoryView = editButton
      return .none
    default:
      return .none
    }
  }
}
struct SectionOfCustomData {
  var header: String
  var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
  typealias Item = ItemizeData
  
  init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}
