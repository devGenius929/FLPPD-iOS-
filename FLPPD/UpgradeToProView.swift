//
//  UpgradeToProView.swift
//  FLPPD
//
//  Created by PC on 6/8/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class UpgradeToProView:UIView{
  let upgradeToProButton = UIButton()
  let upgradeLabel = UILabel()
  lazy var attributes:[NSAttributedStringKey:Any] = {[unowned self]()->[NSAttributedStringKey:Any] in
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.firstLineHeadIndent = 153
    paragraphStyle.lineSpacing = 5
    paragraphStyle.lineHeightMultiple = 1.3
    let attributes:[NSAttributedStringKey:Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.paragraphStyle.rawValue):paragraphStyle,NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.lightGray,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont.systemFont(ofSize: 15)]
    return attributes
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  func setupView(){
    addSubview(upgradeToProButton)
    addSubview(upgradeLabel)
    upgradeToProButton.setImage(UIImage(named:"upgradeToPro"), for: .normal)
    upgradeToProButton.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
    upgradeToProButton.setTopInSuperview(16, priority: UILayoutPriority(rawValue: 999))
    upgradeLabel.setLeadingInSuperview(16, priority: UILayoutPriority(rawValue: 1000))
    upgradeLabel.setTopInSuperview(16, priority: UILayoutPriority(rawValue: 999))
    upgradeLabel.setTrailingInSuperview(-16, priority: UILayoutPriority(rawValue: 999))
    upgradeLabel.numberOfLines = 0
  }
}
