//
//  AddNewCell.swift
//  FLPPD
//
//  Created by PC on 5/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class AddNewCell:FeaturesCell{
  let addNewLabel = UILabel()
  let tap = UITapGestureRecognizer()
  override func setupView(){
    super.setupView()
    self.addGestureRecognizer(tap)
    addSubview(addNewLabel)
    addNewLabel.text = "Add new"

    let labelLeadingConstraint = NSLayoutConstraint(item: addNewLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 8)
    let labelCenterYConstraint = NSLayoutConstraint(item: addNewLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    //let labelBottomConstraint = NSLayoutConstraint(item: addNewLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 5)
    addNewLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([labelLeadingConstraint,labelCenterYConstraint/*,labelBottomConstraint*/])
    accessoryButton.backgroundColor = UIColor.green
    accessoryButton.setTitle("+", for: .normal)
    
    

  }
}
