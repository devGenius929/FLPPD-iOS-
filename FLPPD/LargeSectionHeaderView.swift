//
//  LargeSectionHeaderView.swift
//  FLPPD
//
//  Created by PC on 6/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class LargeSectionHeaderView:UIView{
  let headerLabel = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  func setupView(){
    addSubview(headerLabel)
    backgroundColor = UIColor.white
    headerLabel.textColor = UIColor.lightGray
    headerLabel.font = UIFont.systemFont(ofSize: 18)
    headerLabel.setLeadingInSuperview(20, priority: UILayoutPriority(rawValue: 1000))
    headerLabel.setBottomInSuperview(-10, priority: UILayoutPriority(rawValue: 1000))
  }
  
}
