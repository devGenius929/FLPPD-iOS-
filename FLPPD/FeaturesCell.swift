//
//  FeaturesCell.swift
//  FLPPD
//
//  Created by PC on 5/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class FeaturesCell:UIView{
  private enum accessoryButtonSize{
    static let width:CGFloat = 30.0
    static let height:CGFloat = 30.0
    static let cornerRadius:CGFloat = width/2
  }
  
  let accessoryButton = UIButton()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  func setupView(){
    self.backgroundColor = UIColor.white
    self.addTopSeparator(0.5, rightInset: 0, leftInset: 8, color: UIColor.lightGray)
    addSubview(accessoryButton)
        
    let buttonTrailingConstraint = NSLayoutConstraint(item: accessoryButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -8)
    let buttonWidthConstraint = NSLayoutConstraint(item: accessoryButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: accessoryButtonSize.width)
    let buttonHeightConstant = NSLayoutConstraint(item: accessoryButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: accessoryButtonSize.height)
    let buttonCenterYConstraint = NSLayoutConstraint(item: accessoryButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    accessoryButton.translatesAutoresizingMaskIntoConstraints = false
    accessoryButton.backgroundColor = UIColor.red
    accessoryButton.setTitle("✕", for: .normal)
    accessoryButton.layer.cornerRadius = accessoryButtonSize.cornerRadius
    
    NSLayoutConstraint.activate([buttonTrailingConstraint,buttonWidthConstraint,buttonHeightConstant,buttonCenterYConstraint])
  }

}
