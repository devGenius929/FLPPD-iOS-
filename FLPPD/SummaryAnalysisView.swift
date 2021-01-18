//
//  SummaryAnalysisView.swift
//  FLPPD
//
//  Created by PC on 6/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class SummaryAnalysisView:UIScrollView{
  let stackView = UIStackView()
  private let purchaseAndRehabHeader = LargeSectionHeaderView()
  let purchasePriceView = StandardFormFieldWithRightLabel()
  let financedRehabCostsView = StandardFormFieldWithRightLabel()
  let amountFinancedView = StandardFormFieldWithRightLabel()
  let downPaymentView = StandardFormFieldWithRightLabel()
  private let separator1 = UIView.createSeparatorView(1,rightInset:-20,leftInset:20,color:UIColor.lightGray)
  let purchaseCostsView = StandardFormFieldWithRightLabel()
  let rehabCostsView = StandardFormFieldWithRightLabel()
  let totalCashNeededView = StandardFormFieldWithRightLabel()
  private let separator2 = UIView.createSeparatorView(1, rightInset: -20, leftInset: 20, color: UIColor.lightGray)
  private let valuationHeader = LargeSectionHeaderView()
  let pricePerSquareFootView = StandardFormFieldWithRightLabel()
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
    let views = [purchaseAndRehabHeader,purchasePriceView,financedRehabCostsView,amountFinancedView,downPaymentView,separator1,purchaseCostsView,rehabCostsView,totalCashNeededView,separator2,valuationHeader,pricePerSquareFootView]
    for view in views{
      stackView.addArrangedSubview(view)
    }
    //MARK:Purchase and Rehab
    purchaseAndRehabHeader.headerLabel.text = "Purchase & Rehab"
    purchaseAndRehabHeader.setHeightConstraint(60, priority: UILayoutPriority(rawValue: 1000))
    purchasePriceView.leftLabel.text = "Purchase Price:"
    financedRehabCostsView.leftLabel.text = "Financed Rehab Costs:"
    financedRehabCostsView.middleLabel.text = "+"
    amountFinancedView.leftLabel.text = "Amount Financed:"
    amountFinancedView.middleLabel.text = "-"
    downPaymentView.leftLabel.text = "Down Payment:"
    downPaymentView.middleLabel.text = "="
    separator1.setHeightConstraint(20, priority: UILayoutPriority(rawValue: 1000))
    purchaseCostsView.leftLabel.text = "Purchase Costs:"
    purchaseCostsView.middleLabel.text = "+"
    rehabCostsView.leftLabel.text = "Rehab Costs:"
    rehabCostsView.middleLabel.text = "+"
    totalCashNeededView.leftLabel.text = "Total Cash Needed:"
    totalCashNeededView.middleLabel.text = "="
    //MARK:Valuation
    separator2.setHeightConstraint(20, priority: UILayoutPriority(rawValue: 1000))
    valuationHeader.headerLabel.text = "Valuation"
    valuationHeader.setHeightConstraint(40, priority: UILayoutPriority(rawValue: 1000))
    pricePerSquareFootView.leftLabel.text = "Price Per Square Foot"
    let viewsWith36HeightConstraint = [purchasePriceView,financedRehabCostsView,amountFinancedView,downPaymentView,purchaseCostsView,rehabCostsView,totalCashNeededView,pricePerSquareFootView]
    for view in viewsWith36HeightConstraint{
      view.setHeightConstraint(36, priority: UILayoutPriority(rawValue: 999))
    }
  }
}
