//
//  WorksheetItemizeView.swift
//  FLPPD
//
//  Created by PC on 6/8/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class WorksheetItemizeView:UIView{
  let selectedGesture = UITapGestureRecognizer()
  let icon = UIImageView(image:UIImage(named:"lock"))
  let detailIndicator = UIImageView(image:UIImage(named: "chevron"))
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
    addGestureRecognizer(selectedGesture)
    addSubview(icon)
    addSubview(leftLabel)
    addSubview(detailIndicator)
    detailIndicator.centerVerticallyInSuperview()
    detailIndicator.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 1000))
    setDisabled()
  }
  func setEnabled(){
    selectedGesture.isEnabled = true
    leftLabel.textColor = UIColor.black
    icon.isHidden = true
    leftLabel.frame = CGRect(x: 16, y: center.y + leftLabel.intrinsicContentSize.height/2, width: leftLabel.intrinsicContentSize.width, height: leftLabel.intrinsicContentSize.height)
  }
  func setDisabled(){
    selectedGesture.isEnabled = false
    leftLabel.textColor = UIColor.lightGray
    icon.isHidden = false

    icon.frame = CGRect(x: 16, y: center.y + icon.intrinsicContentSize.height/2, width: icon.intrinsicContentSize.width, height: icon.intrinsicContentSize.height)
    leftLabel.frame = CGRect(x: icon.frame.maxX + 16, y: center.y + leftLabel.intrinsicContentSize.height/2, width: leftLabel.intrinsicContentSize.width, height: leftLabel.intrinsicContentSize.height)
  }
}
