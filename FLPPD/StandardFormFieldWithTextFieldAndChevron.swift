//
//  StandardFormFieldWithTextFieldAndChevron.swift
//  FLPPD
//
//  Created by PC on 10/10/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class StandardFormFieldWithTextFieldAndChevron:UIView{
  let textField = UITextField()
  let detailIcon = UIImageView(image: UIImage(named:"chevron"))
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
    addSubview(detailIcon)
    textField.centerVerticallyInSuperview()
    textField.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 999))
    textField.setTrailingInSuperview(-24, priority: UILayoutPriority(rawValue: 999))
    detailIcon.centerVerticallyInSuperview()
    detailIcon.setWidthConstraint(8, priority: UILayoutPriority(rawValue: 999))
    detailIcon.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 999))
  }
}
