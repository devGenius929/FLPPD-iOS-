//
//  EvalPropertyWorksheetViewController.swift
//  FLPPD
//
//  Created by PC on 5/24/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class EvalPropertyWorksheetViewController:UIViewController{
  private var worksheetForm:WorksheetView!
  private let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: nil, action: nil)
  private let pickerView = UIPickerView()
  var coreDataController:CoreDataController!
  var property:Property!
  private let mainDisposeBag = DisposeBag()
  private var disposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    navigationItem.title = "Worksheet"
    resetButton.tintColor = UIColor.red
    navigationItem.rightBarButtonItem = resetButton
    worksheetForm = property.isKind(of: RentalProperty.self) ? RentalWorksheetView() : FlipWorksheetView()
    view.addSubview(worksheetForm)
    worksheetForm.pinToSuperView()
    //MARK: fill in saved worksheet data
    property.rx.observe(Worksheet.self, "worksheet").subscribe(onNext:{[unowned self](worksheet)->Void in
      if let flipWorksheet = worksheet as? FlipWorksheet{
        self.setupFlipWorksheet(flipWorksheet)
      }else if let rentalWorksheet = worksheet as? RentalWorksheet{
        self.setupRentalWorksheet(rentalWorksheet)
      }
    }).disposed(by: mainDisposeBag)

    worksheetForm.isProUser.value = true
    
      }
  func setupFlipWorksheet(_ flipWorksheet:FlipWorksheet){
    disposeBag = DisposeBag()
    setupWorksheet(flipWorksheet)
    guard let flipWorksheetForm = worksheetForm as? FlipWorksheetView else{
      return
    }
    //MARK:Percent of ARV
    flipWorksheetForm.percentOfARVView.rightTextField.text = flipWorksheet.percentOfARV?.stringValue
    flipWorksheetForm.customLoanAmountSegmentedControl.selectedSegmentIndex = flipWorksheet.customLoanAsPercentOfARV ? 1 : 0
    flipWorksheetForm.customLoanAmountSegmentedControl.rx.selectedSegmentIndex.subscribe(onNext:{(index)->Void in
      flipWorksheet.customLoanAsPercentOfARV = index == 0 ? false : true
    }).disposed(by: disposeBag)
    flipWorksheetForm.customLoanAsPercentOfARV.value = flipWorksheet.customLoanAsPercentOfARV
    bindWorksheetDecimalAttribute(flipWorksheet, keyPath: "percentOfARV", textfield: flipWorksheetForm.percentOfARVView.rightTextField, minVal: 0, maxVal: 100, disposeBag: disposeBag)
    flipWorksheet.rx.observe(NSDecimalNumber.self, "percentOfARV").subscribe(onNext:{Void in
      calculateItemizedPurchaseCostsTotal(flipWorksheet)
    }).disposed(by: disposeBag)
    flipWorksheet.rx.observe(Bool.self, "customLoanAsPercentOfARV").subscribe(onNext:{Void in
      calculateItemizedPurchaseCostsTotal(flipWorksheet)
    }).disposed(by: disposeBag)
    //MARK:Recalculate itemize total
    flipWorksheet.rx.observe(NSDecimalNumber.self, "purchasePrice").subscribe(onNext:{Void in
      calculateItemizeHoldingCostsTotal(flipWorksheet)
      calculateItemizedSellingCostsTotal(flipWorksheet)
    }).disposed(by: disposeBag)

    //MARK:Cost overrun
    flipWorksheetForm.costOverrunView.rightTextField.text = flipWorksheet.costOverrun!.stringValue
    bindWorksheetDecimalAttribute(flipWorksheet, keyPath: "costOverrun", textfield: flipWorksheetForm.costOverrunView.rightTextField, minVal: 0, maxVal: 100, disposeBag: disposeBag)
    //MARK:Finance rehab cost
    flipWorksheet.rx.observe(Bool.self, "useFinancing").subscribe(onNext:{(isOn)->Void in
      guard let isOn = isOn,isOn else{
        flipWorksheetForm.financeRehabCostView.isHidden = true
        flipWorksheetForm.percentageToFinanceView.isHidden = true
        return
      }
      flipWorksheetForm.financeRehabCostView.isHidden = false
      flipWorksheetForm.financeRehabCost.value = flipWorksheet.financeRehabCosts
    }).disposed(by: disposeBag)
    flipWorksheetForm.financeRehabCostView.rightSwitch.isOn = flipWorksheet.financeRehabCosts
    flipWorksheetForm.financeRehabCostView.rightSwitch.rx.isOn.subscribe(onNext:{(isOn)->Void in
      flipWorksheet.financeRehabCosts = isOn
    }).disposed(by: disposeBag)
    flipWorksheet.rx.observe(Bool.self, "financeRehabCosts").subscribe(onNext:{(isOn)->Void in
      calculateItemizedPurchaseCostsTotal(flipWorksheet)
    }).disposed(by: disposeBag)
    //MARK:Percentage to finance
    flipWorksheetForm.percentageToFinanceView.rightTextField.text = flipWorksheet.percentageToFinance?.stringValue
    bindWorksheetDecimalAttribute(flipWorksheet, keyPath: "percentageToFinance", textfield: flipWorksheetForm.percentageToFinanceView.rightTextField, minVal: 0, maxVal: 100, disposeBag: disposeBag)
    flipWorksheet.rx.observe(NSDecimalNumber.self, "percentageToFinance").subscribe(onNext:{Void in
      calculateItemizedPurchaseCostsTotal(flipWorksheet)
    }).disposed(by: disposeBag)
    //MARK:Setup Holding Costs
    flipWorksheet.holdingCosts?.rx.observe(NSDecimalNumber.self, "total").subscribe(onNext:{(total)->Void in
      guard let total = total else{
        return
      }
      flipWorksheetForm.holdingCostsTotalView.rightTextField.text = total.decimalFormat()
    }).disposed(by: disposeBag)

    bindWorksheetDecimalAttribute(flipWorksheet, keyPath: "holdingCosts.total", textfield: flipWorksheetForm.holdingCostsTotalView.rightTextField, minVal: 0, maxVal: nil, disposeBag: disposeBag)
    
    flipWorksheet.holdingCosts?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{(itemizedTotal)->Void in
      guard let itemizedTotal = itemizedTotal else{
        return
      }
      flipWorksheetForm.holdingCostsItemizeTotalView.rightTextField.text = itemizedTotal.decimalFormat()
    }).disposed(by: disposeBag)
    
    flipWorksheet.holdingCosts?.rx.observe(Bool.self, "itemized").subscribe(onNext:{(itemized)->Void in
      guard let itemized = itemized else{
        return
      }
      flipWorksheetForm.holdingCostsItemized.value = itemized
    }).disposed(by: disposeBag)
    //MARK:Setup Selling Costs
    flipWorksheet.sellingCosts?.rx.observe(NSDecimalNumber.self, "total").subscribe(onNext:{(total)->Void in
      guard let total = total else{
        return
      }
      flipWorksheetForm.sellingCostsTotalView.rightTextField.text = total.stringValue
    }).disposed(by: disposeBag)
    
    bindWorksheetDecimalAttribute(flipWorksheet, keyPath: "sellingCosts.total", textfield: flipWorksheetForm.sellingCostsTotalView.rightTextField, minVal: 0, maxVal: 100, disposeBag: disposeBag)
    
    flipWorksheet.sellingCosts?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{(itemizedTotal)->Void in
      guard let itemizedTotal = itemizedTotal else{
        return
      }
      flipWorksheetForm.sellingCostsItemizeTotalView.rightTextField.text = itemizedTotal.decimalFormat()
    }).disposed(by: disposeBag)
    
    flipWorksheet.sellingCosts?.rx.observe(Bool.self, "itemized").subscribe(onNext:{(itemized)->Void in
      guard let itemized = itemized else{
        return
      }
      flipWorksheetForm.sellingCostsItemized.value = itemized
    }).disposed(by: disposeBag)
    //MARK:Holding period
    flipWorksheetForm.holdingPeriodView.rightTextField.text = flipWorksheet.holdingPeriod?.stringValue
    bindWorksheetDecimalAttribute(flipWorksheet, keyPath: "holdingPeriod", textfield: flipWorksheetForm.holdingPeriodView.rightTextField, minVal: 0, maxVal: 12, disposeBag: disposeBag)
    
    flipWorksheetForm.holdingCostsItemizeView.selectedGesture.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = ItemizeViewController()
      vc.property = self.property
      vc.coreDataController = self.coreDataController
      vc.itemizeItemType = ItemizeItemType.HoldingCosts
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: disposeBag)
    
    flipWorksheetForm.sellingCostsItemizeView.selectedGesture.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = ItemizeViewController()
      vc.property = self.property
      vc.coreDataController = self.coreDataController
      vc.itemizeItemType = ItemizeItemType.SellingCosts
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: disposeBag)
  }
  func setupRentalWorksheet(_ rentalWorksheet:RentalWorksheet){
    disposeBag = DisposeBag()
    setupWorksheet(rentalWorksheet)
    guard let rentalWorksheetForm = worksheetForm as? RentalWorksheetView else{
      return
    }
    //MARK:Calculate itemize total
    rentalWorksheet.rx.observe(NSDecimalNumber.self, "purchasePrice").subscribe(onNext:{Void in
      calculateItemizedExpensesTotal(rentalWorksheet)
    }).disposed(by: disposeBag)
    //MARK:Gross rent
    rentalWorksheetForm.grossRentView.rightTextField.text = rentalWorksheet.grossRent?.decimalFormat()
    rentalWorksheet.rx.observe(NSDecimalNumber.self, "grossRent").subscribe(onNext:{Void in
      calculateItemizedExpensesTotal(rentalWorksheet)
    }).disposed(by: disposeBag)
    rentalWorksheet.rx.observe(Int32.self, "rentCollection").subscribe(onNext:{(value)->Void in
      for rentCollection in RentCollectionType.cases{
        if value == rentCollection.coreDataValue{
          rentalWorksheetForm.grossRentView.rightTextField.placeholder = rentCollection.placeholder
        }
      }
      calculateItemizedExpensesTotal(rentalWorksheet)
    }).disposed(by: disposeBag)
    bindWorksheetDecimalAttribute(rentalWorksheet, keyPath: "grossRent", textfield: rentalWorksheetForm.grossRentView.rightTextField, minVal: 0, maxVal: nil, disposeBag: disposeBag)
    //MARK:Rent Collection
    pickerView.dataSource = self
    pickerView.delegate = self
    rentalWorksheetForm.rentCollectionView.rightTextField.inputView = pickerView
    pickerView.rx.itemSelected.subscribe(onNext:{(row,component)->Void in
      rentalWorksheet.rentCollection = Int32(row)
      for value in RentCollectionType.cases{
        if Int32(row) == value.coreDataValue{
          rentalWorksheet.rentCollection = value.coreDataValue
        }
      }
    }).disposed(by: disposeBag)
    
    rentalWorksheet.rx.observe(Int32.self, "rentCollection").subscribe(onNext:{(value)->Void in
      for rentCollection in RentCollectionType.cases{
        if value == rentCollection.coreDataValue{
          rentalWorksheetForm.rentCollectionView.rightTextField.text = rentCollection.stringValue
        }
      }
    }).disposed(by: disposeBag)
    //MARK:Other income
    rentalWorksheetForm.otherIncomeView.selectedGesture.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = ItemizeViewController()
      vc.property = self.property
      vc.coreDataController = self.coreDataController
      vc.itemizeItemType = ItemizeItemType.Income
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: disposeBag)
    //MARK:Expenses
    rentalWorksheetForm.expensesTotalView.rightTextField.text = rentalWorksheet.expenses?.total?.stringValue
    bindWorksheetDecimalAttribute(rentalWorksheet, keyPath: "expenses.total", textfield: rentalWorksheetForm.expensesTotalView.rightTextField, minVal: 0, maxVal: 100, disposeBag: disposeBag)
    rentalWorksheet.expenses?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{(value)->Void in
      rentalWorksheetForm.expensesItemizeTotalView.rightTextField.text = value!.decimalFormat()
    }).disposed(by: disposeBag)
    rentalWorksheetForm.expensesItemizeView.selectedGesture.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = ItemizeViewController()
      vc.property = self.property
      vc.coreDataController = self.coreDataController
      vc.itemizeItemType = ItemizeItemType.Expenses
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: disposeBag)
    
    rentalWorksheet.expenses?.rx.observe(Bool.self, "itemized").subscribe(onNext:{(itemized)->Void in
      guard let itemized = itemized else{
        return
      }
      rentalWorksheetForm.expensesItemized.value = itemized
    }).disposed(by: disposeBag)
    //MARK:Vacancy
    rentalWorksheetForm.vacancyView.rightTextField.text = rentalWorksheet.vacancy?.stringValue
    bindWorksheetDecimalAttribute(rentalWorksheet, keyPath: "vacancy", textfield: rentalWorksheetForm.vacancyView.rightTextField, minVal: 0, maxVal: 100, disposeBag: disposeBag)
    rentalWorksheet.rx.observe(NSDecimalNumber.self, "vacancy").subscribe(onNext:{Void in
      calculateItemizedExpensesTotal(rentalWorksheet)
    }).disposed(by: disposeBag)
    //MARK:Appreciation
    rentalWorksheetForm.appreciationView.rightTextField.text = rentalWorksheet.appreciation?.stringValue
    bindWorksheetDecimalAttribute(rentalWorksheet, keyPath: "appreciation", textfield: rentalWorksheetForm.appreciationView.rightTextField, minVal: nil, maxVal: nil, disposeBag: disposeBag)
    //MARK:Income increase
    rentalWorksheetForm.incomeIncreaseView.rightTextField.text = rentalWorksheet.incomeIncrease?.stringValue
    bindWorksheetDecimalAttribute(rentalWorksheet, keyPath: "incomeIncrease", textfield: rentalWorksheetForm.incomeIncreaseView.rightTextField, minVal: -1000, maxVal: 1000, disposeBag: disposeBag)
    //MARK:Expenses increase 
    rentalWorksheetForm.expensesIncreaseView.rightTextField.text = rentalWorksheet.expensesIncrease?.stringValue
    bindWorksheetDecimalAttribute(rentalWorksheet, keyPath: "expensesIncrease", textfield: rentalWorksheetForm.expensesIncreaseView.rightTextField, minVal: -1000, maxVal: 1000, disposeBag: disposeBag)
    //MARK:Selling costs
    rentalWorksheetForm.sellingCostsView.rightTextField.text = rentalWorksheet.sellingCosts?.stringValue
    bindWorksheetDecimalAttribute(rentalWorksheet, keyPath: "sellingCosts", textfield: rentalWorksheetForm.sellingCostsView.rightTextField, minVal: -50, maxVal: 100, disposeBag: disposeBag)
    //MARK:Land value
    rentalWorksheetForm.landValueView.rightTextField.text = rentalWorksheet.landValue?.decimalFormat()
    bindWorksheetDecimalAttribute(rentalWorksheet, keyPath: "landValue", textfield: rentalWorksheetForm.landValueView.rightTextField, minVal: 0, maxVal: nil, disposeBag: disposeBag)
    
  }
  func setupWorksheet(_ worksheet:Worksheet){
    //MARK:Purchase Price
    //MARK:Calculate itemize total
    worksheet.rx.observe(NSDecimalNumber.self, "purchasePrice").subscribe(onNext:{[unowned self](purchasePrice)->Void in
      calculateItemizedPurchaseCostsTotal(worksheet)
      self.worksheetForm.purchasePriceView.rightTextField.text = purchasePrice!.decimalFormat()
    }).disposed(by: disposeBag)
    
    worksheetForm.purchasePriceView.rightTextField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{[unowned self] Void in
      let purchasePrice = NSDecimalNumber(string: self.worksheetForm.purchasePriceView.rightTextField.text)
      guard purchasePrice != NSDecimalNumber.notANumber else{
        worksheet.purchasePrice = NSDecimalNumber.zero
        self.worksheetForm.purchasePriceView.rightTextField.text = "0"
        return
      }
      worksheet.purchasePrice = purchasePrice
      if purchasePrice.isGreaterThanDecimal(worksheet.afterRepairValue!){
        worksheet.afterRepairValue = purchasePrice
      }
    }).disposed(by: disposeBag)
    //MARK:After repair value
    worksheet.rx.observe(NSDecimalNumber.self, "afterRepairValue").subscribe(onNext:{[unowned self](afterRepairValue)->Void in
      guard let afterRepairValue = afterRepairValue else{
        return
      }
      self.worksheetForm.afterRepairValueView.rightTextField.text = afterRepairValue.decimalFormat()
    }).disposed(by: disposeBag)
    bindWorksheetDecimalAttribute(worksheet, keyPath: "afterRepairValue", textfield: worksheetForm.afterRepairValueView.rightTextField, minVal: 0, maxVal: nil, disposeBag: disposeBag)
    //MARK:Use financing
    worksheetForm.useFinancingView.rightSwitch.isOn = worksheet.useFinancing
    bindWorksheetBoolAttribute(worksheet, keyPath: "useFinancing", uiswitch: worksheetForm.useFinancingView.rightSwitch)
    worksheet.rx.observe(Bool.self, "useFinancing").subscribe(onNext:{Void in
      calculateItemizedPurchaseCostsTotal(worksheet)
    }).disposed(by: disposeBag)
    worksheetForm.useFinancing.value = worksheet.useFinancing
    //MARK:Mortgage insurance
    worksheetForm.mortgageInsuranceView.rightSwitch.isOn = worksheet.amortizingFinancing!.useMortgageInsurance
    bindWorksheetBoolAttribute(worksheet, keyPath: "amortizingFinancing.useMortgageInsurance", uiswitch: worksheetForm.mortgageInsuranceView.rightSwitch)
    worksheetForm.useMortgageInsurance.value = worksheet.amortizingFinancing!.useMortgageInsurance
    //MARK:Custom loan amount
    worksheetForm.customLoanAmountView.rightSwitch.isOn = worksheet.customLoanAmount
    bindWorksheetBoolAttribute(worksheet, keyPath: "customLoanAmount", uiswitch: worksheetForm.customLoanAmountView.rightSwitch)
    worksheet.rx.observe(Bool.self, "customLoanAmount").subscribe(onNext:{Void in
      calculateItemizedPurchaseCostsTotal(worksheet)
    }).disposed(by: disposeBag)
    worksheetForm.useCustomLoanAmount.value = worksheet.customLoanAmount
    //MARK:Amortizing Interest Only
    worksheetForm.amortizingInterestOnlySegmentedControl.selectedSegmentIndex = worksheet.amortizing ? 0 : 1
    worksheetForm.amortizingInterestOnlySegmentedControl.rx.selectedSegmentIndex.subscribe(onNext:{(index)->Void in
      worksheet.amortizing = index == 0 ? true : false
    }).disposed(by: disposeBag)
    worksheetForm.amortizing.value = worksheet.amortizing
    //MARK:Down payment
    worksheetForm.downPaymentView.rightTextField.text = worksheet.downPayment?.decimalFormat()
    bindWorksheetDecimalAttribute(worksheet,keyPath:"downPayment",textfield: worksheetForm.downPaymentView.rightTextField, minVal: 0, maxVal: 100, disposeBag: disposeBag)
    worksheet.rx.observe(NSDecimalNumber.self, "downPayment").subscribe(onNext:{Void in
      calculateItemizedPurchaseCostsTotal(worksheet)
    }).disposed(by: disposeBag)
    //MARK:Loan Amount
    worksheetForm.loanAmountView.rightTextField.text = worksheet.loanAmount?.decimalFormat()
    bindWorksheetDecimalAttribute(worksheet, keyPath: "loanAmount", textfield: worksheetForm.loanAmountView.rightTextField, minVal: 0, maxVal: nil, disposeBag: disposeBag)
    worksheet.rx.observe(NSDecimalNumber.self, "loanAmount").subscribe(onNext:{Void in
      calculateItemizedPurchaseCostsTotal(worksheet)
    }).disposed(by: disposeBag)
    //MARK:Interest rate
    worksheetForm.interestRateView.rightTextField.text = worksheet.interestRate?.stringValue
    bindWorksheetDecimalAttribute(worksheet, keyPath: "interestRate", textfield: worksheetForm.interestRateView.rightTextField, minVal: 0, maxVal: 100, disposeBag: disposeBag)
    //MARK:Loan term
    worksheetForm.loanTermView.rightTextField.text = worksheet.amortizingFinancing?.loanTerm?.stringValue
    bindWorksheetDecimalAttribute(worksheet, keyPath: "amortizingFinancing.loanTerm", textfield: worksheetForm.loanTermView.rightTextField, minVal: 0, maxVal: 100,disposeBag: disposeBag)
    //MARK:Upfront
    worksheetForm.upfrontView.rightTextField.text = worksheet.amortizingFinancing?.mortgageInsurance?.upfront?.stringValue
    bindWorksheetDecimalAttribute(worksheet, keyPath: "amortizingFinancing.mortgageInsurance.upfront", textfield: worksheetForm.upfrontView.rightTextField, minVal: 0, maxVal: 100,disposeBag: disposeBag)
    //MARK:Recurring
    worksheetForm.recurringView.rightTextField.text = worksheet.amortizingFinancing?.mortgageInsurance?.recurring?.stringValue
    bindWorksheetDecimalAttribute(worksheet, keyPath: "amortizingFinancing.mortgageInsurance.recurring", textfield: worksheetForm.recurringView.rightTextField, minVal: 0, maxVal: 100,disposeBag: disposeBag)
    //MARK:Setup purchase costs
    worksheet.purchaseCosts?.rx.observe(NSDecimalNumber.self, "total").subscribe(onNext:{[unowned self](total)->Void in
      guard let total = total else{
        return
      }
      self.worksheetForm.purchaseCostsTotalView.rightTextField.text = total.stringValue
    }).disposed(by: disposeBag)
    
    bindWorksheetDecimalAttribute(worksheet, keyPath: "purchaseCosts.total", textfield: worksheetForm.purchaseCostsTotalView.rightTextField, minVal: 0, maxVal: 100,disposeBag: disposeBag)
    
    worksheet.purchaseCosts?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{[unowned self](itemizedTotal)->Void in
      guard let itemizedTotal = itemizedTotal else{
        return
      }
      self.worksheetForm.purchaseCostsItemizedTotalView.rightTextField.text = itemizedTotal.decimalFormat()
    }).disposed(by: disposeBag)
    
    worksheet.purchaseCosts?.rx.observe(Bool.self, "itemized").subscribe(onNext:{[unowned self](itemized)->Void in
      guard let itemized = itemized else{
        return
      }
      self.worksheetForm.purchaseCostsItemized.value = itemized
    }).disposed(by: disposeBag)
    //MARK:Setup rehab costs
    worksheet.rehabCosts?.rx.observe(NSDecimalNumber.self, "total").subscribe(onNext:{[unowned self](total)->Void in
      guard let total = total else{
        return
      }
      self.worksheetForm.rehabCostsTotalView.rightTextField.text = total.decimalFormat()
    }).disposed(by: disposeBag)
    
    bindWorksheetDecimalAttribute(worksheet, keyPath: "rehabCosts.total", textfield: worksheetForm.rehabCostsTotalView.rightTextField, minVal: 0, maxVal: nil, disposeBag: disposeBag)
    
    worksheet.rehabCosts?.rx.observe(NSDecimalNumber.self, "itemizedTotal").subscribe(onNext:{[unowned self](itemizedTotal)->Void in
      guard let itemizedTotal = itemizedTotal else{
        return
      }
      self.worksheetForm.rehabCostsItemizedTotalView.rightTextField.text = itemizedTotal.decimalFormat()
    }).disposed(by: disposeBag)
    
    worksheet.rehabCosts?.rx.observe(Bool.self, "itemized").subscribe(onNext:{[unowned self](itemized)->Void in
      guard let itemized = itemized else{
        return
      }
      self.worksheetForm.rehabCostsItemized.value = itemized
    }).disposed(by: disposeBag)
    resetButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      let alert = UIAlertController(title: "Reset property worksheet to default values?", message: "This action cannot be undone", preferredStyle: .actionSheet)
      let reset = UIAlertAction(title: "Reset", style: .destructive, handler: {Void in
        self.property.worksheet = self.property.isKind(of: FlipProperty.self) ? generateDefaultFlipWorksheet(context: self.coreDataController.persistentContainer.viewContext) : generateDefaultRentalWorksheet(context: self.coreDataController.persistentContainer.viewContext)
      })
      let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(cancel)
      alert.addAction(reset)
      self.present(alert, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    worksheetForm.purchaseCostsItemizeView.selectedGesture.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = ItemizeViewController()
      vc.property = self.property
      vc.coreDataController = self.coreDataController
      vc.itemizeItemType = ItemizeItemType.PurchaseCosts
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: disposeBag)
    
    worksheetForm.rehabCostsItemizeView.selectedGesture.rx.event.subscribe(onNext:{[unowned self] Void in
      let vc = ItemizeViewController()
      vc.property = self.property
      vc.coreDataController = self.coreDataController
      vc.itemizeItemType = ItemizeItemType.RehabCosts
      self.navigationController?.pushViewController(vc, animated: true)
    }).disposed(by: disposeBag)
  }
  
  func bindWorksheetBoolAttribute(_ worksheet:Worksheet,keyPath:String,uiswitch:UISwitch){
    uiswitch.rx.isOn.subscribe(onNext:{(isOn)->Void in
      worksheet.setValue(isOn, forKeyPath: keyPath)
    }).disposed(by: disposeBag)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    coreDataController.saveMainContext()
  }
}

extension EvalPropertyWorksheetViewController:UIPickerViewDataSource,UIPickerViewDelegate{
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 3
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    for value in RentCollectionType.cases{
      if Int32(row) == value.coreDataValue{
        return value.stringValue
      }
    }
    return nil
  }
}
