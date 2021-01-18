//
//  ProjectionsView.swift
//  FLPPD
//
//  Created by PC on 6/25/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class ProjectionsView:UIScrollView{
  private let disposeBag = DisposeBag()
  private let stackView = UIStackView()
  private let incomeHeader = LargeSectionHeaderView()
  let grossRentView = StandardFormFieldWithRightLabel()
  let vacancyView = StandardFormFieldWithRightLabel()
  let otherIncomeView = StandardFormFieldWithRightLabel()
  let operatingIncomeView = StandardFormFieldWithRightLabel()
  private let separator1 = UIView.createSeparatorView(1, rightInset: 20, leftInset: 20, color: UIColor.lightGray)
  private let expensesHeader = LargeSectionHeaderView()
  let expensesViews:Variable<[UIView]> = Variable([])
  let totalExpensesView = StandardFormFieldWithRightLabel()
  let operatingExpensesView = StandardFormFieldWithRightLabel()
  private let separator2 = UIView.createSeparatorView(1, rightInset: 20, leftInset: 20, color: UIColor.lightGray)
  private let cashFlowHeader = LargeSectionHeaderView()
  let cashFlowOperatingIncomeView = StandardFormFieldWithRightLabel()
  let cashFlowOperatingExpensesView = StandardFormFieldWithRightLabel()
  let netOperatingIncomeView = StandardFormFieldWithRightLabel()
  private let separator3 = UIView.createSeparatorView(1, rightInset: 20, leftInset: 20, color: UIColor.lightGray)
  let loanPaymentsView = StandardFormFieldWithRightLabel()
  let cashFlowView = StandardFormFieldWithRightLabel()
  private let separator4 = UIView.createSeparatorView(1, rightInset: 20, leftInset: 20, color: UIColor.lightGray)
  private let equityAccumulationHeader = LargeSectionHeaderView()
  let propertyValueView = StandardFormFieldWithRightLabel()
  let loanBalanceView = StandardFormFieldWithRightLabel()
  let totalEquityView = StandardFormFieldWithRightLabel()
  private let separator5 = UIView.createSeparatorView(1, rightInset: 20, leftInset: 20, color: UIColor.lightGray)
  private let taxBenefitsHeader = LargeSectionHeaderView()
  let depreciationView = StandardFormFieldWithRightLabel()
  let loanInterestView = StandardFormFieldWithRightLabel()
  private let separator6 = UIView.createSeparatorView(1, rightInset: 20, leftInset: 20, color: UIColor.lightGray)
  private let returnsHeader = LargeSectionHeaderView()
  let capRateView = StandardFormFieldWithRightLabel()
  let cashOnCashView = StandardFormFieldWithRightLabel()
  let returnOnInvestmentView = StandardFormFieldWithRightLabel()
  let internalRateOfReturnView = StandardFormFieldWithRightLabel()
  private let separator7 = UIView.createSeparatorView(1, rightInset: 20, leftInset: 20, color: UIColor.lightGray)
  private let ratiosHeader = LargeSectionHeaderView()
  let rentToValueView = StandardFormFieldWithRightLabel()
  let grossRentMultiplierView = StandardFormFieldWithRightLabel()
  let debtCoverageRatioView = StandardFormFieldWithRightLabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  func setupView() {
    self.backgroundColor = UIColor.white
    //MARK:Main Stackview
    addSubview(stackView)
    stackView.axis = .vertical
    stackView.pinToSuperView()
    stackView.pinWidthToSuperview()
    let views = [incomeHeader,grossRentView,vacancyView,otherIncomeView,operatingIncomeView,separator1,expensesHeader,totalExpensesView,operatingExpensesView,separator2,cashFlowHeader,cashFlowOperatingIncomeView,cashFlowOperatingExpensesView,netOperatingIncomeView,separator3,loanPaymentsView,cashFlowView,separator4,equityAccumulationHeader,propertyValueView,loanBalanceView,totalEquityView,separator5,taxBenefitsHeader,depreciationView,loanInterestView,separator6,returnsHeader,capRateView,cashOnCashView,returnOnInvestmentView,internalRateOfReturnView ,separator7,ratiosHeader,rentToValueView,grossRentMultiplierView,debtCoverageRatioView]
    for view in views{
      stackView.addArrangedSubview(view)
    }
    //MARK:Income
    incomeHeader.headerLabel.text = "Income"
    incomeHeader.setHeightConstraint(60, priority: UILayoutPriority(rawValue: 1000))
    grossRentView.leftLabel.text = "Gross Rent:"
    vacancyView.leftLabel.text = "Vacancy:"
    vacancyView.middleLabel.text = "-"
    otherIncomeView.leftLabel.text = "Other Income:"
    otherIncomeView.middleLabel.text = "+"
    operatingIncomeView.leftLabel.text = "Operating Income:"
    operatingIncomeView.middleLabel.text = "="
    //MARK:Expenses
    expensesHeader.headerLabel.text = "Expenses"
    totalExpensesView.leftLabel.text = "Total Expenses:"
    operatingExpensesView.leftLabel.text = "Operating Expenses:"
    operatingExpensesView.middleLabel.text = "="
    //MARK:Cash Flow
    cashFlowHeader.headerLabel.text = "Cash Flow"
    cashFlowOperatingIncomeView.leftLabel.text = "Operating Income:"
    cashFlowOperatingExpensesView.leftLabel.text = "Operating Expenses:"
    cashFlowOperatingExpensesView.middleLabel.text = "-"
    netOperatingIncomeView.leftLabel.text = "Net Operating Income:"
    netOperatingIncomeView.middleLabel.text = "="
    loanPaymentsView.leftLabel.text = "Loan Payments:"
    cashFlowView.leftLabel.text = "Cash Flow:"
    cashFlowView.middleLabel.text = "="
    //MARK:Equity Accumulation
    equityAccumulationHeader.headerLabel.text = "Equity Accumulation"
    propertyValueView.leftLabel.text = "Property Value:"
    loanBalanceView.leftLabel.text = "Loan Balance:"
    loanBalanceView.middleLabel.text = "-"
    totalEquityView.leftLabel.text = "Total Equity:"
    totalEquityView.middleLabel.text = "="
    //MARK:Tax Benefits
    taxBenefitsHeader.headerLabel.text = "Tax Benefits"
    depreciationView.leftLabel.text = "Depreciation:"
    loanInterestView.leftLabel.text = "Loan Interest:"
    //MARK:Returns
    returnsHeader.headerLabel.text = "Returns"
    capRateView.leftLabel.text = "Cap Rate:"
    cashOnCashView.leftLabel.text = "Cash on Cash:"
    returnOnInvestmentView.leftLabel.text = "Return on Investment:"
    internalRateOfReturnView.leftLabel.text = "Internal Rate of Return:"
    //MARK:Ratios
    ratiosHeader.headerLabel.text = "Ratios"
    rentToValueView.leftLabel.text = "Rent to Value:"
    grossRentMultiplierView.leftLabel.text = "Gross Rent Multiplier:"
    debtCoverageRatioView.leftLabel.text = "Debt Coverage Ratio:"
    let viewsWith20HeightConstraint = [separator1,separator2,separator3,separator4,separator5,separator6,separator7]
    for view in viewsWith20HeightConstraint{
      view.setHeightConstraint(20, priority: UILayoutPriority(rawValue: 999))
    }
    let viewsWith40HeightConstraint = [expensesHeader,cashFlowHeader,equityAccumulationHeader,taxBenefitsHeader,returnsHeader,ratiosHeader]
    for view in viewsWith40HeightConstraint{
      view.setHeightConstraint(40, priority: UILayoutPriority(rawValue: 999))
    }
    let viewsWith36HeightConstraint = [grossRentView,vacancyView,otherIncomeView,operatingIncomeView,totalExpensesView,operatingExpensesView,cashFlowOperatingIncomeView,cashFlowOperatingExpensesView,netOperatingIncomeView,loanPaymentsView,cashFlowView,propertyValueView,loanBalanceView,totalEquityView,depreciationView,loanInterestView,capRateView,cashOnCashView,returnOnInvestmentView,internalRateOfReturnView ,rentToValueView,grossRentMultiplierView,debtCoverageRatioView]
    for view in viewsWith36HeightConstraint{
      view.setHeightConstraint(36, priority: UILayoutPriority(rawValue: 999))
    }
    
    expensesViews.asObservable().subscribe(onNext:{[unowned self](views)->Void in
      for view in self.stackView.arrangedSubviews{
        if view.tag == 1{
          view.removeFromSuperview()
          self.stackView.removeArrangedSubview(view)
        }
      }
      for view in views{
        view.tag = 1
        view.setHeightConstraint(36, priority: UILayoutPriority(rawValue: 1000))
        let index = self.stackView.arrangedSubviews.index(of: self.operatingExpensesView)
        self.stackView.insertArrangedSubview(view, at:index! - 1)
      }
    }).disposed(by: disposeBag)
  }
}
