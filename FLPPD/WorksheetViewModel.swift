//
//  WorksheetViewModel.swift
//  FLPPD
//
//  Created by PC on 6/4/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

func bindWorksheetInt32Attribute(_ worksheet:Worksheet,keyPath:String,textfield:UITextField,minVal:Int?,maxVal:Int?,disposeBag:DisposeBag){
  //USE THIS ONLY FOR Int32 PROPERTY
  textfield.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
    guard let text = textfield.text,var value = Int32(text) else{
      worksheet.setValue(Int32(0), forKeyPath: keyPath)
      textfield.text = "0"
      return
    }
    if let minVal = minVal,let minVal32 = Int32(exactly:minVal),value < minVal32 {
      value = minVal32
    }
    if let maxVal = maxVal,let maxVal32 = Int32(exactly:maxVal),value > maxVal32 {
      value = maxVal32
    }
    worksheet.setValue(value, forKeyPath: keyPath)
    textfield.text = value.formatDecimal()
  }).disposed(by: disposeBag)
}

func bindWorksheetDecimalAttribute(_ worksheet:Worksheet,keyPath:String,textfield:UITextField,minVal:Int?,maxVal:Int?,disposeBag:DisposeBag){
  //USE THIS ONLY FOR DECIMAL PROPERTY
  textfield.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
    guard let text = textfield.text else{
      return
    }
    let value = NSDecimalNumber(string: text).limitToRange(maxVal, min: minVal)
    worksheet.setValue(value, forKeyPath: keyPath)
    textfield.text = value.decimalFormat()
  }).disposed(by: disposeBag)
}

func setupWorksheetFormFieldLayout(_ view:UIView,leftLabel:UILabel,rightSwitch:UISwitch){
  view.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
  view.addSubview(leftLabel)
  view.addSubview(rightSwitch)
  leftLabel.centerVerticallyInSuperview()
  leftLabel.setLeadingInSuperview(16,priority: UILayoutPriority(rawValue: 1000))
  rightSwitch.centerVerticallyInSuperview()
  rightSwitch.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
}
func setupWorksheetFormFieldLayout(_ view:UIView,leftLabel:UILabel,rightTF:FloatLabelTextField){
  leftLabel.centerVerticallyInSuperview()
  leftLabel.setLeadingInSuperview(16,priority: UILayoutPriority(rawValue: 1000))
  rightTF.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
  rightTF.setTopInSuperview(5, priority: UILayoutPriority(rawValue: 999))
  rightTF.setBottomInSuperview(-5, priority: UILayoutPriority(rawValue: 999))
  rightTF.textAlignment = .right
  let horizontalSpacingConstraint = NSLayoutConstraint(item: rightTF, attribute: .leading, relatedBy: .equal, toItem: leftLabel, attribute: .trailing, multiplier: 1, constant: 8)
  NSLayoutConstraint.activate([horizontalSpacingConstraint])
}
func setupStandardCenterYCellLayout(_ view:UIView,leftView:UIView,rightView:UIView){
  view.addSubview(leftView)
  view.addSubview(rightView)
  leftView.centerVerticallyInSuperview()
  leftView.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
  rightView.centerVerticallyInSuperview()
  rightView.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
}
