//
//  FlipWorksheetView.swift
//  FLPPD
//
//  Created by PC on 6/4/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class FlipWorksheetView:WorksheetView{
  let holdingCostsItemized = Variable(false)
  let sellingCostsItemized = Variable(false)
  let financeRehabCost = Variable(false)
  let customLoanAsPercentOfARV = Variable(false)
  let customLoanAmountSegmentedControlView = UIView()
  let customLoanAmountSegmentedControl = UISegmentedControl(items: ["Set Amount","Percent of ARV"])
  let percentOfARVView = StandardFormFieldWithFloatingText()
  let costOverrunHeader = UIView()
  let costOverrunView = StandardFormFieldWithFloatingText()
  let financeRehabCostView = StandardFormFieldWithSwitch()
  let percentageToFinanceView = StandardFormFieldWithFloatingText()
  let holdingCostsHeader = SectionHeaderView()
  let holdingCostsTotalView = StandardFormFieldWithFloatingText()
  let holdingCostsItemizeTotalView = StandardFormFieldWithFloatingText()
  let holdingCostsItemizeView = WorksheetItemizeView()
  let holdingCostsUpgradeToProView = UpgradeToProView()
  let sellingCostsHeader = SectionHeaderView()
  let sellingCostsTotalView = StandardFormFieldWithFloatingText()
  let sellingCostsItemizeTotalView = StandardFormFieldWithFloatingText()
  let sellingCostsItemizeView = WorksheetItemizeView()
  let sellingCostsUpgradeToProView = UpgradeToProView()
  let assumptionsHeader = SectionHeaderView()
  let holdingPeriodView = StandardFormFieldWithFloatingText()
  override func setupView(){
    super.setupView()
    customLoanAmountStackView.insertArrangedSubview(customLoanAmountSegmentedControlView, at: 0)
    customLoanAmountSegmentedControlView.addTopSeparator(0.5, rightInset: 0, leftInset: 16, color: UIColor.lightGray)
    customLoanAmountSegmentedControlView.backgroundColor = UIColor.white
    customLoanAmountSegmentedControlView.addSubview(customLoanAmountSegmentedControl)
    customLoanAmountSegmentedControl.centerVerticallyInSuperview()
    customLoanAmountSegmentedControl.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
    customLoanAmountSegmentedControl.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
    customLoanAmountSegmentedControlView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    customLoanAmountSegmentedControl.tintColor = UIColor.darkerGold
    customLoanAmountStackView.addArrangedSubview(percentOfARVView)
    percentOfARVView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    percentOfARVView.addTopSeparator(0.5, rightInset: 0, leftInset: 16, color: UIColor.lightGray)
    percentOfARVView.leftLabel.text = "Percent of ARV"
    percentOfARVView.rightTextField.placeholder = "%"
    percentOfARVView.textFieldValueType.value = .Percent
    loanAmountView.addTopSeparator(0.5, rightInset: 0, leftInset: 16, color: UIColor.lightGray)
    
    let additionalView = [costOverrunHeader,costOverrunView,financeRehabCostView,percentageToFinanceView,holdingCostsHeader,holdingCostsTotalView,holdingCostsItemizeTotalView,holdingCostsItemizeView,holdingCostsUpgradeToProView,sellingCostsHeader,sellingCostsTotalView,sellingCostsItemizeTotalView,sellingCostsItemizeView,sellingCostsUpgradeToProView,assumptionsHeader,holdingPeriodView]
    for view in additionalView{
      stackView.addArrangedSubview(view)
    }
    //MARK:Cost Overrun
    costOverrunHeader.setHeightConstraint(22, priority: UILayoutPriority(rawValue: 999))
    costOverrunHeader.backgroundColor = UIColor.groupTableViewBackground
    costOverrunView.leftLabel.text = "Cost Overrun"
    costOverrunView.rightTextField.placeholder = "%"
    costOverrunView.textFieldValueType.value = .Percent
    costOverrunView.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    costOverrunView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    //MARK:Finance Rehab Cost
    financeRehabCostView.leftLabel.text = "Finance Rehab Cost"
    financeRehabCostView.addTopSeparator(0.5, rightInset: 0, leftInset: 16, color: UIColor.lightGray)
    financeRehabCostView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    //MARK:Percentage to Finance
    percentageToFinanceView.leftLabel.text = "Percentage to Finance"
    percentageToFinanceView.rightTextField.placeholder = "%"
    percentageToFinanceView.textFieldValueType.value = .Percent
    percentageToFinanceView.addTopSeparator(0.5, rightInset: 0, leftInset: 16, color: UIColor.lightGray)
    percentageToFinanceView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    //MARK:Holding Cost
    holdingCostsHeader.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    holdingCostsTotalView.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    holdingCostsItemizeTotalView.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    holdingCostsItemizeView.addTopSeparator(0.5, rightInset: 0, leftInset: 16, color: UIColor.lightGray)
    holdingCostsHeader.headerLabel.text = "HOLDING COSTS"
    holdingCostsTotalView.leftLabel.text = "Total"
    holdingCostsTotalView.rightTextField.placeholder = "$ Per Month"
    holdingCostsTotalView.textFieldValueType.value = .SetAmount
    holdingCostsItemizeTotalView.leftLabel.text = "Itemized Total"
    holdingCostsItemizeTotalView.rightTextField.placeholder = "$ Per Month"
    holdingCostsItemizeTotalView.isUserInteractionEnabled = false
    holdingCostsHeader.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    holdingCostsTotalView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    holdingCostsItemizeTotalView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    holdingCostsItemizeView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    holdingCostsUpgradeToProView.setHeightConstraint(81, priority: UILayoutPriority(rawValue: 999))
    //MARK:Selling Cost
    sellingCostsTotalView.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    sellingCostsItemizeTotalView.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    sellingCostsItemizeView.addTopSeparator(0.5, rightInset: 0, leftInset: 16, color: UIColor.lightGray)
    sellingCostsHeader.headerLabel.text = "SELLING COSTS"
    sellingCostsTotalView.leftLabel.text = "Total"
    sellingCostsTotalView.rightTextField.placeholder = "% of Price"
    sellingCostsTotalView.textFieldValueType.value = .Percent
    sellingCostsItemizeTotalView.leftLabel.text = "Itemized Total"
    sellingCostsItemizeTotalView.rightTextField.placeholder = "$"
    sellingCostsItemizeTotalView.isUserInteractionEnabled = false
    sellingCostsHeader.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    sellingCostsTotalView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    sellingCostsItemizeTotalView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    sellingCostsItemizeView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    sellingCostsUpgradeToProView.setHeightConstraint(81, priority: UILayoutPriority(rawValue: 999))
    //MARK:Assumptions
    assumptionsHeader.headerLabel.text = "ASSUMPTIONS"
    assumptionsHeader.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    holdingPeriodView.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    holdingPeriodView.leftLabel.text = "Holding Period"
    holdingPeriodView.rightTextField.placeholder = "Months"
    holdingPeriodView.textFieldValueType.value = .Percent
    holdingPeriodView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    
    isProUser.asObservable().subscribe(onNext:{[unowned self](isPro)->Void in
      self.holdingCostsUpgradeToProView.isHidden = isPro
      self.sellingCostsUpgradeToProView.isHidden = isPro
      if isPro{
        self.holdingCostsItemizeView.setEnabled()
        self.sellingCostsItemizeView.setEnabled()
      }else{
        self.holdingCostsItemizeView.setDisabled()
        self.sellingCostsItemizeView.setDisabled()
      }
    }).disposed(by: disposeBag)
    holdingCostsItemized.asObservable().subscribe(onNext:{[unowned self](itemized)->Void in
      self.holdingCostsTotalView.isHidden = itemized
      self.holdingCostsItemizeTotalView.isHidden = !itemized
      self.holdingCostsItemizeView.leftLabel.text = itemized ? "Edit" : "Itemize"
      self.holdingCostsItemizeView.leftLabel.sizeToFit()
    }).disposed(by: disposeBag)
    sellingCostsItemized.asObservable().subscribe(onNext:{[unowned self](itemized)->Void in
      self.sellingCostsTotalView.isHidden = itemized
      self.sellingCostsItemizeTotalView.isHidden = !itemized
      self.sellingCostsItemizeView.leftLabel.text = itemized ? "Edit" : "Itemize"
      self.sellingCostsItemizeView.leftLabel.sizeToFit()
    }).disposed(by: disposeBag)
    financeRehabCostView.rightSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.financeRehabCost.value = isOn
    }).disposed(by: disposeBag)
    financeRehabCost.asObservable().subscribe(onNext:{[unowned self](financeRehabCost)->Void in
      self.percentageToFinanceView.isHidden = !financeRehabCost
      if self.percentageToFinanceView.rightTextField.isFirstResponder && !financeRehabCost{
        self.percentageToFinanceView.rightTextField.resignFirstResponder()
      }
    }).disposed(by: disposeBag)
    customLoanAmountSegmentedControl.rx.selectedSegmentIndex.subscribe(onNext:{[unowned self](index)->Void in
      if index == 1 {
        if self.loanAmountView.rightTextField.isFirstResponder{
          self.percentOfARVView.rightTextField.becomeFirstResponder()
        }
      }else{
        if self.percentOfARVView.rightTextField.isFirstResponder{
          self.loanAmountView.rightTextField.becomeFirstResponder()
        }
      }
      self.customLoanAsPercentOfARV.value = index == 0 ? false : true
    }).disposed(by: disposeBag)
    customLoanAsPercentOfARV.asObservable().subscribe(onNext:{[unowned self](usePercentageOfARV)->Void in
      self.percentOfARVView.isHidden = !usePercentageOfARV
      self.loanAmountView.isHidden = usePercentageOfARV
    }).disposed(by: disposeBag)
    textfields += [costOverrunView.rightTextField,percentageToFinanceView.rightTextField,holdingCostsTotalView.rightTextField,sellingCostsTotalView.rightTextField,holdingPeriodView.rightTextField]
    if let index = textfields.index(of: loanAmountView.rightTextField){
      textfields.insert(percentOfARVView.rightTextField, at: index)
    }
    setupKeyboardToolbar()
  }
}
