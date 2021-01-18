//
//  StandardFormFieldWithRightLabel.swift
//  FLPPD
//
//  Created by PC on 6/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class StandardFormFieldWithRightLabel:StandardFormField{
  let rightLabel = UILabel()
  let middleLabel = UILabel()
  let bottomLabel = UILabel()
  override func setupView() {
    super.setupView()
    addSubview(rightLabel)
    addSubview(middleLabel)
    addSubview(bottomLabel)
    for constraint in leftLabel.constraints{
      NSLayoutConstraint.deactivate([constraint])
    }
    //MARK:Left label
    leftLabel.centerVerticallyInSuperview()
    leftLabel.setLeadingInSuperview(20, priority: UILayoutPriority(rawValue: 1000))
    leftLabel.font = UIFont.systemFont(ofSize: 15)
    //MARK:Right label
    rightLabel.centerVerticallyInSuperview()
    rightLabel.setTrailingInSuperview(-20, priority: UILayoutPriority(rawValue: 1000))
    rightLabel.font = UIFont.systemFont(ofSize: 15)
    //MARK:Middle label 
    middleLabel.centerVerticallyInSuperview()
    let middleLabelHorizontalConstraint = NSLayoutConstraint(item: middleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 40)
    //MARK:Bottom label
    bottomLabel.setTrailingInSuperview(-20, priority: UILayoutPriority(rawValue: 1000))
    let bottomLabelTopConstraint = NSLayoutConstraint(item: bottomLabel, attribute: .top, relatedBy: .equal, toItem: rightLabel, attribute: .bottom, multiplier: 1, constant: 0)
    NSLayoutConstraint.activate([bottomLabelTopConstraint,middleLabelHorizontalConstraint])
    bottomLabel.font = UIFont.systemFont(ofSize: 9)
  }
}
