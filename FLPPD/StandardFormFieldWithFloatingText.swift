//
//  StandardFormFieldWithFloatingText.swift
//  FLPPD
//
//  Created by PC on 6/4/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
enum TextFieldValueType{
  case Percent
  case SetAmount
  case Standard
}
class StandardFormFieldWithFloatingText:StandardFormField{
  let rightTextField = FloatLabelTextField()
  private let selectedGesture = UITapGestureRecognizer()
  private let disposeBag = DisposeBag()
  let textFieldValueType:Variable<TextFieldValueType> = Variable(.Standard)
  override func setupView() {
    super.setupView()
    addSubview(rightTextField)
    addGestureRecognizer(selectedGesture)
    rightTextField.font = UIFont.systemFont(ofSize: 14)
    setupWorksheetFormFieldLayout(self, leftLabel: leftLabel, rightTF: rightTextField)
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
