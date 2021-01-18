//
//  StandardFormFieldWithDetail.swift
//  FLPPD
//
//  Created by PC on 6/12/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class StandardFormFieldWithDetail:StandardFormField{
  let detailIcon = UIImageView(image: UIImage(named:"chevron"))
  let rightTextField = UITextField()
  let selectedGesture = UITapGestureRecognizer()
  override func setupView() {
    super.setupView()
    addGestureRecognizer(selectedGesture)
    addSubview(detailIcon)
    addSubview(rightTextField)
    leftLabel.centerVerticallyInSuperview()
    leftLabel.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
    detailIcon.centerVerticallyInSuperview()
    detailIcon.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
    detailIcon.setWidthConstraint(8, priority: UILayoutPriority(rawValue: 1000))
    rightTextField.centerVerticallyInSuperview()
    rightTextField.textAlignment = .right
    let rightConstraint = NSLayoutConstraint(item: detailIcon, attribute: .leading, relatedBy: .equal, toItem: rightTextField, attribute: .trailing, multiplier: 1, constant: 8)
    rightConstraint.priority = UILayoutPriority(rawValue: 999)
    let leftConstraint = NSLayoutConstraint(item: rightTextField, attribute: .leading, relatedBy: .equal, toItem: leftLabel, attribute: .trailing, multiplier: 1, constant: 16)
    NSLayoutConstraint.activate([rightConstraint,leftConstraint])
  }
}
