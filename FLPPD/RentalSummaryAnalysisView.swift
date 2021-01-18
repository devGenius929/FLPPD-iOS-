//
//  RentalSummaryAnalysisView.swift
//  FLPPD
//
//  Created by PC on 6/20/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RentalSummaryAnalysisView:SummaryAnalysisView{
  private let separator3 = UIView.createSeparatorView(1, rightInset: -20, leftInset: 20, color: UIColor.lightGray)
  let operationHeader = LargeSectionHeaderView()
  let operationPeriodView = UIView()
  let operationSegmentedControl = UISegmentedControl(items: ["Monthly","Yearly"])
  let grossRentView = StandardFormFieldWithRightLabel()
  let vacancyView = StandardFormFieldWithRightLabel()
  let otherIncomeView = StandardFormFieldWithRightLabel()
  let operatingIncomeView = StandardFormFieldWithRightLabel()
  let operatingExpensesView = StandardFormFieldWithRightLabel()
  let netOperatingIncomeView = StandardFormFieldWithRightLabel()
  let loanPaymentView = StandardFormFieldWithRightLabel()
  let cashFlowView = StandardFormFieldWithRightLabel()
  private let separator4 = UIView.createSeparatorView(1, rightInset: -20, leftInset: 20, color: UIColor.lightGray)
  let returnsHeader = LargeSectionHeaderView()
  let capRateView = StandardFormFieldWithRightLabel()
  let cashOnCashView = StandardFormFieldWithRightLabel()
  let returnOnInvestmentView = StandardFormFieldWithRightLabel()
  let internalRateOfReturnView = StandardFormFieldWithRightLabel()
  private let separator5 = UIView.createSeparatorView(1, rightInset: -20, leftInset: 20, color: UIColor.lightGray)
  let ratiosHeader = LargeSectionHeaderView()
  let rentToValueView = StandardFormFieldWithRightLabel()
  let grossRentMultiplierView = StandardFormFieldWithRightLabel()
  let debtCoverageRatioView = StandardFormFieldWithRightLabel()
  private let disposeBag = DisposeBag()
  override func setupView() {
    super.setupView()
    let addtionalViews = [separator3,operationHeader,operationPeriodView,grossRentView,vacancyView,otherIncomeView,operatingIncomeView,operatingExpensesView,netOperatingIncomeView,loanPaymentView,cashFlowView,separator4,returnsHeader,capRateView,cashOnCashView,returnOnInvestmentView,internalRateOfReturnView,separator5,ratiosHeader,rentToValueView,grossRentMultiplierView,debtCoverageRatioView]
    for view in addtionalViews{
      stackView.addArrangedSubview(view)
    }
    //MARK:Operation
    separator3.setHeightConstraint(20, priority: UILayoutPriority(rawValue: 1000))
    operationHeader.setHeightConstraint(40, priority: UILayoutPriority(rawValue: 1000))
    operationHeader.headerLabel.text = "Operation"
    operationPeriodView.addSubview(operationSegmentedControl)
    operationSegmentedControl.pinToSuperView()
    operationSegmentedControl.tintColor = UIColor.clear
    let selectedAttributes = [NSAttributedStringKey.foregroundColor:UIColor.darkerGold,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)]
    let normalAttributes = [NSAttributedStringKey.foregroundColor:UIColor.lightGray,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)]
    operationSegmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
    operationSegmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
    grossRentView.leftLabel.text = "Gross Rent:"
    vacancyView.leftLabel.text = "Vacancy:"
    vacancyView.middleLabel.text = "-"
    otherIncomeView.leftLabel.text = "Other Income:"
    otherIncomeView.middleLabel.text = "+"
    operatingIncomeView.leftLabel.text = "Operating Income:"
    operatingIncomeView.middleLabel.text = "="
    operatingExpensesView.leftLabel.text = "Operating Expenses:"
    operatingExpensesView.middleLabel.text = "-"
    netOperatingIncomeView.leftLabel.text = "Net Operating Income:"
    netOperatingIncomeView.middleLabel.text = "="
    loanPaymentView.leftLabel.text = "Loan Payments:"
    loanPaymentView.middleLabel.text = "-"
    cashFlowView.leftLabel.text = "Cash Flow:"
    cashFlowView.middleLabel.text = "="
    //MARK:Returns
    separator4.setHeightConstraint(20, priority: UILayoutPriority(rawValue: 1000))
    returnsHeader.setHeightConstraint(40, priority: UILayoutPriority(rawValue: 1000))
    returnsHeader.headerLabel.text = "Returns"
    capRateView.leftLabel.text = "Cap Rate:"
    cashOnCashView.leftLabel.text = "Cash on Cash:"
    returnOnInvestmentView.leftLabel.text = "Return on Investment:"
    internalRateOfReturnView.leftLabel.text = "Internal Rate of Return:"
    //MARK:Ratios
    separator5.setHeightConstraint(20, priority: UILayoutPriority(rawValue: 1000))
    ratiosHeader.setHeightConstraint(40, priority: UILayoutPriority(rawValue: 1000))
    ratiosHeader.headerLabel.text = "Ratios"
    rentToValueView.leftLabel.text = "Rent to Value:"
    grossRentMultiplierView.leftLabel.text = "Gross Rent Multiplier:"
    debtCoverageRatioView.leftLabel.text = "Debt Coverage Ratio:"
    let viewsWith36HeightConstraint = [operationPeriodView,grossRentView,vacancyView,otherIncomeView,operatingIncomeView,operatingExpensesView,netOperatingIncomeView,loanPaymentView,cashFlowView,capRateView,cashOnCashView,returnOnInvestmentView,internalRateOfReturnView,rentToValueView,grossRentMultiplierView,debtCoverageRatioView]
    for view in viewsWith36HeightConstraint{
      view.setHeightConstraint(36, priority: UILayoutPriority(rawValue: 999))
    }
  }
}
