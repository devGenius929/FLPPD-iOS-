//
//  FlipSummaryAnalysisView.swift
//  FLPPD
//
//  Created by PC on 6/17/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class FlipSummaryAnalysisView:SummaryAnalysisView{
  private let separator3 = UIView.createSeparatorView(1, rightInset: -20, leftInset: 20, color: UIColor.lightGray)
  let holdingCostsHeader = LargeSectionHeaderView()
  let loanPaymentsView = StandardFormFieldWithRightLabel()
  let recurringExpensesView = StandardFormFieldWithRightLabel()
  let holdingCostsTotalView = StandardFormFieldWithRightLabel()
  let holdingCostsViews:Variable<[UIView]> = Variable([])
  private let separator4 = UIView.createSeparatorView(1, rightInset: -20, leftInset: 20, color: UIColor.lightGray)
  let saleAndProfitHeader = LargeSectionHeaderView()
  let afterRepairValueView = StandardFormFieldWithRightLabel()
  let sellingCostsView = StandardFormFieldWithRightLabel()
  let saleProceedsView = StandardFormFieldWithRightLabel()
  let loanRepaymentView = StandardFormFieldWithRightLabel()
  let holdingCostsView = StandardFormFieldWithRightLabel()
  let investedCashView = StandardFormFieldWithRightLabel()
  let totalProfitView = StandardFormFieldWithRightLabel()
  let separator5 = UIView.createSeparatorView(1, rightInset: -20, leftInset: 20, color: UIColor.lightGray)
  let returnsHeader = LargeSectionHeaderView()
  let returnOnInvestmentView = StandardFormFieldWithRightLabel()
  let annualizedROIView = StandardFormFieldWithRightLabel()
  private let disposeBag = DisposeBag()
  override func setupView() {
    super.setupView()
    let addtionalViews = [separator3,holdingCostsHeader,loanPaymentsView,recurringExpensesView,holdingCostsTotalView,separator4,saleAndProfitHeader,afterRepairValueView,sellingCostsView,saleProceedsView,loanRepaymentView,holdingCostsView,investedCashView,totalProfitView,separator5,returnsHeader,returnOnInvestmentView,annualizedROIView]
    for view in addtionalViews{
      stackView.addArrangedSubview(view)
    }
    //MARK:Holding Costs
    separator3.setHeightConstraint(20, priority: UILayoutPriority(rawValue: 1000))
    holdingCostsHeader.setHeightConstraint(40, priority: UILayoutPriority(rawValue: 1000))
    holdingCostsHeader.headerLabel.text = "Holding Costs"
    loanPaymentsView.leftLabel.text = "Loan Payments:"
    recurringExpensesView.leftLabel.text = "Recurring Expenses:"
    recurringExpensesView.middleLabel.text = "+"
    holdingCostsTotalView.leftLabel.text = "Total:"
    holdingCostsTotalView.middleLabel.text = "="
    holdingCostsViews.asObservable().subscribe(onNext:{[unowned self](views)->Void in
      for view in self.stackView.arrangedSubviews{
        if view.tag == 1{
          view.removeFromSuperview()
          self.stackView.removeArrangedSubview(view)
        }
      }
      for view in views{
        view.tag = 1
        view.setHeightConstraint(36, priority: UILayoutPriority(rawValue: 1000))
        let index = self.stackView.arrangedSubviews.index(of: self.holdingCostsTotalView)
        self.stackView.insertArrangedSubview(view, at:index! - 1)
      }
    }).disposed(by: disposeBag)
    //MARK:Sale & Profit
    separator4.setHeightConstraint(20, priority: UILayoutPriority(rawValue: 1000))
    saleAndProfitHeader.setHeightConstraint(40, priority: UILayoutPriority(rawValue: 1000))
    saleAndProfitHeader.headerLabel.text = "Sale & Profit"
    afterRepairValueView.leftLabel.text = "After Repair Value:"
    sellingCostsView.leftLabel.text = "Selling Costs:"
    sellingCostsView.middleLabel.text = "-"
    saleProceedsView.leftLabel.text = "Sale Proceeds:"
    saleProceedsView.middleLabel.text = "="
    loanRepaymentView.leftLabel.text = "Loan Repayment:"
    loanRepaymentView.middleLabel.text = "-"
    holdingCostsView.leftLabel.text = "Holding Costs:"
    holdingCostsView.middleLabel.text = "-"
    investedCashView.leftLabel.text = "Invested Cash:"
    investedCashView.middleLabel.text = "-"
    totalProfitView.leftLabel.text = "Total Profit:"
    totalProfitView.middleLabel.text = "="
    //MARK:Returns
    separator5.setHeightConstraint(20, priority: UILayoutPriority(rawValue: 1000))
    returnsHeader.setHeightConstraint(40, priority: UILayoutPriority(rawValue: 1000))
    returnsHeader.headerLabel.text = "Returns"
    returnOnInvestmentView.leftLabel.text = "Return on Investment:"
    annualizedROIView.leftLabel.text = "Annualized ROI:"
    let viewsWith36HeightConstraint = [loanPaymentsView,recurringExpensesView,holdingCostsTotalView,afterRepairValueView,sellingCostsView,saleProceedsView,loanRepaymentView,holdingCostsView,investedCashView,totalProfitView,returnOnInvestmentView,annualizedROIView]
    for view in viewsWith36HeightConstraint{
      view.setHeightConstraint(36, priority: UILayoutPriority(rawValue: 999))
    }
  }
}
