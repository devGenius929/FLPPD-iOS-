//
//  StandardFormFieldWithRightTextfield.swift
//  FLPPD
//
//  Created by PC on 7/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class StandardFormFieldWithRightTextfield:StandardFormField{
  let rightTextField = UITextField()
  private let selectedGesture = UITapGestureRecognizer()
  private let disposeBag = DisposeBag()
  let textFieldValueType:Variable<TextFieldValueType> = Variable(.Standard)
  override func setupView() {
    super.setupView()
    addSubview(rightTextField)
    addGestureRecognizer(selectedGesture)
    rightTextField.font = UIFont.systemFont(ofSize: 14)
    rightTextField.textAlignment = .right
    leftLabel.centerVerticallyInSuperview()
    leftLabel.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
    rightTextField.centerVerticallyInSuperview()
    rightTextField.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
    textFieldValueType.asObservable().subscribe(onNext:{[unowned self](valueType)->Void in
      switch valueType{
      case .Percent:
        self.rightTextField.keyboardType = .decimalPad
      case .SetAmount:
        self.rightTextField.keyboardType = .numberPad
      default:
        self.rightTextField.keyboardType = .default
      }
    }).disposed(by: disposeBag)
    selectedGesture.rx.event.subscribe(onNext:{[unowned self] Void in
      self.rightTextField.becomeFirstResponder()
    }).disposed(by: disposeBag)
  }
}
