//
//  StandardFormFieldWithNoLeftLabel.swift
//  FLPPD
//
//  Created by PC on 10/3/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class StandardFormFieldWithNoLeftLabelAndFloatingText:UIView{
  let textField = FloatLabelTextField()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  func setupView(){
    backgroundColor = UIColor.white
    addSubview(textField)
    textField.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 999))
    textField.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 999))
    textField.setTopInSuperview(5, priority: UILayoutPriority(rawValue: 999))
    textField.setBottomInSuperview(-5, priority: UILayoutPriority(rawValue: 999))
    textField.font = UIFont.systemFont(ofSize: 14)
  }
}
