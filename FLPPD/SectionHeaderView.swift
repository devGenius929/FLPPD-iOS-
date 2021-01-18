//
//  SectionHeaderView.swift
//  FLPPD
//
//  Created by PC on 6/8/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class SectionHeaderView:UIView{
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
    backgroundColor = UIColor.groupTableViewBackground
    headerLabel.textColor = UIColor.lightGray
    headerLabel.font = UIFont.systemFont(ofSize: 12)
    headerLabel.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
    headerLabel.setBottomInSuperview(-8, priority: UILayoutPriority(rawValue: 1000))
  }

}
