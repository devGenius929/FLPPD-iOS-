//
//  StandardFormField.swift
//  FLPPD
//
//  Created by PC on 6/4/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class StandardFormField:UIView{
  let leftLabel = UILabel()
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
    addSubview(leftLabel)
  }
}
