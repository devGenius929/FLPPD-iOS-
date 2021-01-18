//
//  StandardFormFieldWithSwitch.swift
//  FLPPD
//
//  Created by PC on 6/4/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class StandardFormFieldWithSwitch:StandardFormField{
  let rightSwitch = UISwitch()
  override func setupView() {
    super.setupView()
    addSubview(rightSwitch)
    setupStandardCenterYCellLayout(self, leftView: leftLabel, rightView: rightSwitch)
  }
}
