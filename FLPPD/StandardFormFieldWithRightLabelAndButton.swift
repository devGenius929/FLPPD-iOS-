//
//  StandardFormFieldWithRightLabelAndButton.swift
//  FLPPD
//
//  Created by PC on 6/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class StandardFormFieldWithRightLabelAndButton:StandardFormFieldWithRightLabel{
  let button = UIButton()
  override func setupView() {
    super.setupView()
    addSubview(button)
    button.setImage(UIImage(named:"question"), for: .normal)
    button.centerVerticallyInSuperview()
    let buttonLeftConstraint = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: leftLabel, attribute: .trailing, multiplier: 1, constant: 5)
    NSLayoutConstraint.activate([buttonLeftConstraint])
  }
}
