//
//  TFFeaturesCell.swift
//  FLPPD
//
//  Created by PC on 5/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class TFFeaturesCell:FeaturesCell{
  let textField = UITextField()
  let disposeBag = DisposeBag()
  override func setupView(){
    super.setupView()
    addSubview(textField)
    textField.placeholder = "Add new"
    textField.autocorrectionType = .no
    let tfTrailingConstraint = NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: accessoryButton, attribute: .leading, multiplier: 1, constant: -8)
    let tfLeadingConstraint = NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 8)
    let tfTopConstraint = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5)
    let tfBottomConstraint = NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 5)
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([tfTrailingConstraint,tfLeadingConstraint,tfTopConstraint,tfBottomConstraint])
    
    accessoryButton.backgroundColor = UIColor.red
    accessoryButton.setTitle("✕", for: .normal)
    textField.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext:{[unowned self] Void in
      self.textField.resignFirstResponder()
    }).disposed(by: disposeBag)
    
  }
}
