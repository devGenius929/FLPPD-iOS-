//
//  SectionHeaderViewWithDetail.swift
//  FLPPD
//
//  Created by PC on 7/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class SectionHeaderViewWithDetail:SectionHeaderView{
  let detailLabel = UILabel()
  override func setupView() {
    super.setupView()
    addSubview(detailLabel)
    detailLabel.numberOfLines = 0
    detailLabel.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
    detailLabel.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
    detailLabel.setTopInSuperview(20, priority: UILayoutPriority(rawValue: 1000))
    detailLabel.font = UIFont.systemFont(ofSize: 15)
    detailLabel.textColor = UIColor.lightGray
  }
}
