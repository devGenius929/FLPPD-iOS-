//
//  WorksheetView.swift
//  FLPPD
//
//  Created by PC on 5/24/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class WorksheetView:UIScrollView{
  var textfields:[UITextField] = []
  let keyboardToolbar = FormKeyboardToolbar()
  let disposeBag = DisposeBag()
  let isProUser = Variable(false)
  let purchaseCostsItemized = Variable(false)
  let rehabCostsItemized = Variable(false)
  let amortizing = Variable(false)
  let useFinancing = Variable(false)
  let useCustomLoanAmount = Variable(false)
  let useMortgageInsurance = Variable(false)
  //MARK:Views
  let stackView = UIStackView()
  let numbersHeaderView = SectionHeaderView()
  let purchasePriceView = StandardFormFieldWithFloatingText()
  let afterRepairValueView = StandardFormFieldWithFloatingText()
  let financingHeaderView = SectionHeaderView()
  let useFinancingView = StandardFormFieldWithSwitch()
  let amortizingInterestOnlyView = UIView()
  let customLoanAmountView = StandardFormFieldWithSwitch()
  let downPaymentView = StandardFormFieldWithFloatingText()
  let customLoanAmountStackView = UIStackView()
  let loanAmountView = StandardFormFieldWithFloatingText()
  let interestRateView = StandardFormFieldWithFloatingText()
  let loanTermView = StandardFormFieldWithFloatingText()
  let mortgageInsuranceView = StandardFormFieldWithSwitch()
  let upfrontView = StandardFormFieldWithFloatingText()
  let recurringView = StandardFormFieldWithFloatingText()
  let purchaseCostsHeader = SectionHeaderView()
  let purchaseCostsTotalView = StandardFormFieldWithFloatingText()
  let purchaseCostsItemizeView = WorksheetItemizeView()
  let purchaseCostsUpgradeToProView = UpgradeToProView()
  let rehabCostHeader = SectionHeaderView()
  let rehabCostsTotalView = StandardFormFieldWithFloatingText()
  let rehabCostsItemizeView = WorksheetItemizeView()
  let rehabCostsUpgradeToProView = UpgradeToProView()
  let financingStackView = UIStackView()
  let amortizingOptionStackView = UIStackView()
  let purchaseCostsItemizedTotalView = StandardFormFieldWithFloatingText()
  let rehabCostsItemizedTotalView = StandardFormFieldWithFloatingText()
  //MARK: Segmented Control
  let amortizingInterestOnlySegmentedControl = UISegmentedControl(items: ["Amortizing","Interest only"])
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  func setupView() {
    self.backgroundColor = UIColor.groupTableViewBackground
    //MARK:Main Stackview
    addSubview(stackView)
    stackView.axis = .vertical
    stackView.pinToSuperView()
    stackView.pinWidthToSuperview()
    //MARK:Numbers header
    numbersHeaderView.headerLabel.text = "NUMBERS"
    //MARK:Purchase price
    purchasePriceView.rightTextField.placeholder = "$"
    purchasePriceView.leftLabel.text = "Purchase Price"
    purchasePriceView.textFieldValueType.value = .SetAmount
    //MARK:After repair value 
    afterRepairValueView.rightTextField.placeholder = "$"
    afterRepairValueView.leftLabel.text = "After Repair Value"
    afterRepairValueView.textFieldValueType.value = .SetAmount
    //MARK:Financing header
    financingHeaderView.headerLabel.text = "FINANCING"
    let arvMessage = UILabel()
    financingHeaderView.addSubview(arvMessage)
    arvMessage.text = "If no repairs are necessary, the after repair value is the same as the current market value"
    arvMessage.numberOfLines = 0
    arvMessage.font = UIFont.systemFont(ofSize: 12)
    arvMessage.textColor = UIColor.lightGray
    arvMessage.setTopInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
    arvMessage.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
    arvMessage.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
    financingHeaderView.setHeightConstraint(109, priority: UILayoutPriority(rawValue: 1000))
    //MARK:Financing
    useFinancingView.leftLabel.text = "Use Financing"
    amortizingInterestOnlyView.backgroundColor = UIColor.white
    amortizingInterestOnlyView.addSubview(amortizingInterestOnlySegmentedControl)
    amortizingInterestOnlySegmentedControl.centerVerticallyInSuperview()
    amortizingInterestOnlySegmentedControl.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
    amortizingInterestOnlySegmentedControl.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
    amortizingInterestOnlySegmentedControl.tintColor = UIColor.darkerGold
    customLoanAmountStackView.addArrangedSubview(loanAmountView)
    customLoanAmountStackView.axis = .vertical
    customLoanAmountView.leftLabel.text = "Custom Loan Amount"
    downPaymentView.leftLabel.text = "Down Payment"
    downPaymentView.textFieldValueType.value = .Percent
    downPaymentView.rightTextField.placeholder = "%"
    loanAmountView.leftLabel.text = "Loan Amount"
    loanAmountView.textFieldValueType.value = .SetAmount
    loanAmountView.rightTextField.placeholder = "$"
    interestRateView.leftLabel.text = "Interest Rate"
    interestRateView.textFieldValueType.value = .Percent
    interestRateView.rightTextField.placeholder = "%"
    loanTermView.leftLabel.text = "Loan Term"
    loanTermView.textFieldValueType.value = .Percent
    loanTermView.rightTextField.placeholder = "Years"
    mortgageInsuranceView.leftLabel.text = "Mortgage Insurance (PMI)"
    upfrontView.leftLabel.text = "Upfront"
    upfrontView.textFieldValueType.value = .Percent
    upfrontView.rightTextField.placeholder = "% of Loan"
    recurringView.leftLabel.text = "Recurring"
    recurringView.textFieldValueType.value = .Percent
    recurringView.rightTextField.placeholder = "% of Loan Per Year"
    
    amortizingOptionStackView.axis = .vertical
    let amortizingOptionViews = [loanTermView,mortgageInsuranceView,upfrontView,recurringView]
    for view in amortizingOptionViews{
      amortizingOptionStackView.addArrangedSubview(view)
    }
    
    financingStackView.axis = .vertical
    let financingViews = [amortizingInterestOnlyView,customLoanAmountView,customLoanAmountStackView,downPaymentView,interestRateView,amortizingOptionStackView]
    for view in financingViews {
      financingStackView.addArrangedSubview(view)
    }
    
    let views = [numbersHeaderView,purchasePriceView,afterRepairValueView,financingHeaderView,useFinancingView,financingStackView,purchaseCostsHeader,purchaseCostsTotalView,purchaseCostsItemizedTotalView,purchaseCostsItemizeView,purchaseCostsUpgradeToProView,rehabCostHeader,rehabCostsTotalView,rehabCostsItemizedTotalView,rehabCostsItemizeView,rehabCostsUpgradeToProView]
    for view in views{
      stackView.addArrangedSubview(view)
    }
    financingStackView.pinWidthToSuperview()
    amortizingOptionStackView.pinWidthToSuperview()
    customLoanAmountStackView.pinWidthToSuperview()
    let viewsWithNoSeparatorInset:[UIView] = [purchasePriceView,financingHeaderView,useFinancingView,purchaseCostsHeader,purchaseCostsTotalView,purchaseCostsUpgradeToProView,rehabCostsTotalView,rehabCostsUpgradeToProView]
    for view in viewsWithNoSeparatorInset{
      view.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    }
    let viewsWithSeparatorInset:[UIView] = [afterRepairValueView,amortizingInterestOnlyView,customLoanAmountView,downPaymentView,loanAmountView,interestRateView,loanTermView,mortgageInsuranceView,upfrontView,recurringView,purchaseCostsItemizeView,rehabCostsItemizeView]
    for view in viewsWithSeparatorInset{
      view.addTopSeparator(0.5, rightInset: 0, leftInset: 16, color: UIColor.lightGray)
    }
    
    
    NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(onNext:{[unowned self](notification)->Void in
      guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else{
        return
      }
      let contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height + 18, 0)
      self.contentInset = contentInset
      self.scrollIndicatorInsets = contentInset
    }).disposed(by: disposeBag)
    
    let viewsWithHeightOf44 = [purchasePriceView,afterRepairValueView,useFinancingView,amortizingInterestOnlyView,customLoanAmountView,downPaymentView,loanAmountView,interestRateView,loanTermView,mortgageInsuranceView,upfrontView,recurringView,purchaseCostsHeader,rehabCostHeader]
    for view in viewsWithHeightOf44{
      view.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    }
    //Handle keyboard hide
    NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext:{[unowned self](notification)->Void in
      let contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
      self.contentInset = contentInset
      self.scrollIndicatorInsets = contentInset
    }).disposed(by: disposeBag)
    //MARK:Setup user type
    isProUser.asObservable().subscribe(onNext:{[unowned self](isPro)->Void in
      self.purchaseCostsUpgradeToProView.isHidden = isPro
      self.rehabCostsUpgradeToProView.isHidden = isPro
      if isPro{
        self.purchaseCostsItemizeView.setEnabled()
        self.rehabCostsItemizeView.setEnabled()
      }else{
        self.purchaseCostsItemizeView.setDisabled()
        self.rehabCostsItemizeView.setDisabled()
        }
      }).disposed(by: disposeBag)
    //MARK:Setup financing
    useFinancingView.rightSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.useFinancing.value = isOn
    }).disposed(by: disposeBag)
    
    useFinancing.asObservable().subscribe(onNext:{[unowned self](useFinancing)->Void in
      self.financingStackView.isHidden = !useFinancing
    }).disposed(by: disposeBag)

    amortizingInterestOnlySegmentedControl.rx.selectedSegmentIndex.subscribe(onNext:{[unowned self](index)->Void in
      self.amortizing.value = index == 0 ? true : false
    }).disposed(by: disposeBag)
    
    amortizing.asObservable().subscribe(onNext:{[unowned self](amortizing)->Void in
      self.amortizingOptionStackView.isHidden = amortizing ? false : true
    }).disposed(by: disposeBag)
    
    customLoanAmountView.rightSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.useCustomLoanAmount.value = isOn
    }).disposed(by: disposeBag)
    
    useCustomLoanAmount.asObservable().subscribe(onNext:{[unowned self](useCustomLoanAmount)->Void in
      self.customLoanAmountStackView.isHidden = !useCustomLoanAmount
      self.downPaymentView.isHidden = useCustomLoanAmount
    }).disposed(by: disposeBag)

    mortgageInsuranceView.rightSwitch.rx.isOn.subscribe(onNext:{[unowned self](isOn)->Void in
      self.useMortgageInsurance.value = isOn
    }).disposed(by: disposeBag)
    
    useMortgageInsurance.asObservable().subscribe(onNext:{[unowned self](useMortgageInsurance)->Void in
      self.upfrontView.isHidden = !useMortgageInsurance
      self.recurringView.isHidden = !useMortgageInsurance
    }).disposed(by: disposeBag)
    
    //MARK:Setup purchase costs
    purchaseCostsTotalView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    purchaseCostsItemizedTotalView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    purchaseCostsItemizeView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    purchaseCostsUpgradeToProView.setHeightConstraint(81, priority: UILayoutPriority(rawValue: 999))
    purchaseCostsItemizedTotalView.isUserInteractionEnabled = false
    purchaseCostsHeader.headerLabel.text = "PURCHASE COSTS"
    purchaseCostsTotalView.leftLabel.text = "Total"
    purchaseCostsTotalView.rightTextField.placeholder = "% of Price"
    purchaseCostsTotalView.textFieldValueType.value = .Percent
    purchaseCostsItemizedTotalView.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    purchaseCostsItemizedTotalView.rightTextField.placeholder = "$"
    purchaseCostsItemizedTotalView.leftLabel.text = "Itemized Total"
    let purchaseCostsUpgradeToProText = NSAttributedString(string: "to itemize purchase costs for your rentals and flips", attributes: purchaseCostsUpgradeToProView.attributes)
    purchaseCostsUpgradeToProView.upgradeLabel.attributedText = purchaseCostsUpgradeToProText
    purchaseCostsItemized.asObservable().subscribe(onNext:{[unowned self](itemized)->Void in
      self.purchaseCostsTotalView.isHidden = itemized
      self.purchaseCostsItemizedTotalView.isHidden = !itemized
      self.purchaseCostsItemizeView.leftLabel.text = itemized ? "Edit" : "Itemize"
      self.purchaseCostsItemizeView.leftLabel.sizeToFit()
    }).disposed(by: disposeBag)
    //MARK:Setup rehab costs
    rehabCostsItemizedTotalView.isUserInteractionEnabled = false
    rehabCostsTotalView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    rehabCostsItemizedTotalView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    rehabCostsItemizeView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    rehabCostsUpgradeToProView.setHeightConstraint(81, priority: UILayoutPriority(rawValue: 999))
    rehabCostHeader.headerLabel.text = "REHAB COSTS"
    rehabCostsTotalView.leftLabel.text = "Total"
    rehabCostsTotalView.rightTextField.placeholder = "$"
    rehabCostsTotalView.textFieldValueType.value = .SetAmount
    rehabCostsItemizedTotalView.rightTextField.placeholder = "$"
    rehabCostsItemizedTotalView.leftLabel.text = "Itemized Total"
    let rehabCostsUpgradeToProText = NSAttributedString(string: "to itemize rehab costs for your rentals and flips", attributes: rehabCostsUpgradeToProView.attributes)
    rehabCostsUpgradeToProView.upgradeLabel.attributedText = rehabCostsUpgradeToProText
    rehabCostsItemized.asObservable().subscribe(onNext:{[unowned self](itemized)->Void in
      self.rehabCostsTotalView.isHidden = itemized
      self.rehabCostsItemizedTotalView.isHidden = !itemized
      self.rehabCostsItemizeView.leftLabel.text = itemized ? "Edit" : "Itemize"
      self.rehabCostsItemizeView.leftLabel.sizeToFit()
    }).disposed(by: disposeBag)
    
    textfields += [purchasePriceView.rightTextField,afterRepairValueView.rightTextField,downPaymentView.rightTextField,loanAmountView.rightTextField,interestRateView.rightTextField,loanTermView.rightTextField,upfrontView.rightTextField,recurringView.rightTextField,purchaseCostsTotalView.rightTextField,rehabCostsTotalView.rightTextField]
  }
  func setupKeyboardToolbar(){
    for tf in textfields{
      tf.inputAccessoryView = keyboardToolbar
    }
    keyboardToolbar.doneButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      self.endEditing(true)
    }).disposed(by: disposeBag)
    
    keyboardToolbar.previousButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      var prevTF:UITextField?
      for (index,tf) in self.textfields.enumerated(){
        if tf.isFirstResponder,index != 0{
          for i in (0...(index - 1)).reversed(){
            let possiblePrevTF = self.textfields[i]
            if let superview = possiblePrevTF.superview,!superview.isHidden,let superSuperview = superview.superview,!superSuperview.isHidden{
              prevTF = possiblePrevTF
              break
            }
          }
          break
        }
      }
      if let prevTF = prevTF{
        prevTF.becomeFirstResponder()
      }else{
        for i in (0...(self.textfields.count - 1)).reversed(){
          let possiblePrevTF = self.textfields[i]
          if let superview = possiblePrevTF.superview,!superview.isHidden,let superSuperview = superview.superview,!superSuperview.isHidden{
            prevTF = possiblePrevTF
            break
          }
        }
        guard let prevTF = prevTF else{
          return
        }
        prevTF.becomeFirstResponder()
      }
    }).disposed(by: disposeBag)
    
    keyboardToolbar.nextButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      var nextTF:UITextField?
      for (index,tf) in self.textfields.enumerated(){
        if tf.isFirstResponder,index != self.textfields.count - 1{
          for i in (index+1)...self.textfields.count - 1{
            let possibleNextTF = self.textfields[i]
            if let superview = possibleNextTF.superview,!superview.isHidden,let superSuperview = superview.superview,!superSuperview.isHidden{
              nextTF = possibleNextTF
              break
            }
          }
          break
        }
      }
      if let nextTF = nextTF{
        nextTF.becomeFirstResponder()
      }else{
        for i in 0...self.textfields.count - 1{
          let possibleNextTF = self.textfields[i]
          if let superview = possibleNextTF.superview,!superview.isHidden,let superSuperview = superview.superview,!superSuperview.isHidden{
            nextTF = possibleNextTF
            break
          }
        }
        guard let nextTF = nextTF else{
          return
        }
        nextTF.becomeFirstResponder()
      }
    }).disposed(by: disposeBag)
  }
}
