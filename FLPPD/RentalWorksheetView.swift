//
//  RentalWorksheetView.swift
//  FLPPD
//
//  Created by PC on 6/4/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class RentalWorksheetView:WorksheetView{
  let expensesItemized = Variable(false)
  private let incomeHeaderView = SectionHeaderView()
  let grossRentView = StandardFormFieldWithFloatingText()
  let rentCollectionView = StandardFormFieldWithDetail()
  let otherIncomeView = WorksheetItemizeView()
  let incomeUpgradeToProView = UpgradeToProView()
  private let expensesHeaderView = SectionHeaderView()
  let expensesTotalView = StandardFormFieldWithFloatingText()
  let expensesItemizeTotalView = StandardFormFieldWithFloatingText()
  let expensesItemizeView = WorksheetItemizeView()
  let expensesUpgradeToProView = UpgradeToProView()
  private let assumptionsHeaderView = SectionHeaderView()
  let vacancyView = StandardFormFieldWithFloatingText()
  let appreciationView = StandardFormFieldWithFloatingText()
  let incomeIncreaseView = StandardFormFieldWithFloatingText()
  let expensesIncreaseView = StandardFormFieldWithFloatingText()
  let sellingCostsView = StandardFormFieldWithFloatingText()
  let landValueView = StandardFormFieldWithFloatingText()
  override func setupView() {
    super.setupView()
    let additionalViews = [incomeHeaderView,grossRentView,rentCollectionView,otherIncomeView,incomeUpgradeToProView,expensesHeaderView,expensesTotalView,expensesItemizeTotalView,expensesItemizeView,expensesUpgradeToProView,assumptionsHeaderView,vacancyView,appreciationView,incomeIncreaseView,expensesIncreaseView,sellingCostsView,landValueView]
    for view in additionalViews{
      stackView.addArrangedSubview(view)
    }
    //MARK:Income
    incomeHeaderView.headerLabel.text = "INCOME"
    grossRentView.leftLabel.text = "Gross Rent"
    grossRentView.textFieldValueType.value = .SetAmount
    rentCollectionView.leftLabel.text = "Rent Collection"
    otherIncomeView.leftLabel.text = "Other Income"
    otherIncomeView.leftLabel.sizeToFit()
    incomeUpgradeToProView.upgradeLabel.attributedText = NSAttributedString(string: "to itemize income for your rentals", attributes: incomeUpgradeToProView.attributes)
    incomeUpgradeToProView.setHeightConstraint(81, priority: UILayoutPriority(rawValue: 999))
    //MARK:Expenses
    expensesHeaderView.headerLabel.text = "EXPENSES"
    expensesTotalView.leftLabel.text = "Total"
    expensesTotalView.rightTextField.placeholder = "% of Rent"
    expensesTotalView.textFieldValueType.value = .Percent
    expensesItemizeTotalView.leftLabel.text = "Itemized Total"
    expensesItemizeTotalView.rightTextField.placeholder = "$ Per Month"
    expensesItemizeTotalView.isUserInteractionEnabled = false
    expensesUpgradeToProView.upgradeLabel.attributedText = NSAttributedString(string: "to itemize expenses for your rentals", attributes: expensesUpgradeToProView.attributes)
    expensesUpgradeToProView.setHeightConstraint(81, priority: UILayoutPriority(rawValue: 999))
    //MARK:Assumptions
    assumptionsHeaderView.headerLabel.text = "ASSUMPTIONS"
    vacancyView.leftLabel.text = "Vacancy"
    vacancyView.rightTextField.placeholder = "%"
    vacancyView.rightTextField.keyboardType = .numberPad
    vacancyView.textFieldValueType.value = .Percent
    appreciationView.leftLabel.text = "Appreciation"
    appreciationView.rightTextField.placeholder = "% Per Year"
    appreciationView.rightTextField.keyboardType = .numberPad
    incomeIncreaseView.leftLabel.text = "Income Increase"
    incomeIncreaseView.rightTextField.placeholder = "% Per Year"
    incomeIncreaseView.rightTextField.keyboardType = .numberPad
    expensesIncreaseView.leftLabel.text = "Expenses Increase"
    expensesIncreaseView.rightTextField.placeholder = "% Per Year"
    expensesIncreaseView.rightTextField.keyboardType = .numberPad
    sellingCostsView.leftLabel.text = "Selling Costs"
    sellingCostsView.rightTextField.placeholder = "% of Sales Price"
    sellingCostsView.rightTextField.keyboardType = .numberPad
    landValueView.leftLabel.text = "Land Value"
    landValueView.rightTextField.placeholder = "$"
    landValueView.rightTextField.keyboardType = .numberPad
    //MARK:views height constraint
    let viewsWith44Height = [incomeHeaderView,grossRentView,rentCollectionView,otherIncomeView,expensesHeaderView,expensesTotalView,expensesItemizeTotalView,expensesItemizeView,assumptionsHeaderView,vacancyView,appreciationView,incomeIncreaseView,expensesIncreaseView,sellingCostsView,landValueView]
    for view in viewsWith44Height{
      view.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    }
    //MARK:add separator
    let viewsWithNoSeparatorInset = [grossRentView,incomeUpgradeToProView,expensesItemizeTotalView,expensesTotalView,expensesUpgradeToProView,vacancyView]
    for view in viewsWithNoSeparatorInset{
      view.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    }
    let viewsWithSeparatorInset = [rentCollectionView,otherIncomeView,expensesItemizeView,appreciationView,incomeIncreaseView,expensesIncreaseView,sellingCostsView,landValueView]
    for view in viewsWithSeparatorInset{
      view.addTopSeparator(0.5, rightInset: 0, leftInset: 16, color: UIColor.lightGray)
    }
    //MARK:keyboard toolbar
    textfields += [grossRentView.rightTextField,rentCollectionView.rightTextField,expensesTotalView.rightTextField,vacancyView.rightTextField,appreciationView.rightTextField,incomeIncreaseView.rightTextField,expensesIncreaseView.rightTextField,sellingCostsView.rightTextField,landValueView.rightTextField]
    setupKeyboardToolbar()
    //MARK:Setup rx
    isProUser.asObservable().subscribe(onNext:{[unowned self](isPro)->Void in
      self.incomeUpgradeToProView.isHidden = isPro
      self.expensesUpgradeToProView.isHidden = isPro
      if isPro{
        self.otherIncomeView.setEnabled()
        self.expensesItemizeView.setEnabled()
      }else{
        self.otherIncomeView.setDisabled()
        self.expensesItemizeView.setDisabled()
      }
    }).disposed(by: disposeBag)
    expensesItemized.asObservable().subscribe(onNext:{[unowned self](itemized)->Void in
      self.expensesTotalView.isHidden = itemized
      self.expensesItemizeTotalView.isHidden = !itemized
      self.expensesItemizeView.leftLabel.text = itemized ? "Edit" : "Itemize"
      self.expensesItemizeView.leftLabel.sizeToFit()
    }).disposed(by: disposeBag)
  }
}
