//
//  FormKeyboardToolbar.swift
//  FLPPD
//
//  Created by PC on 6/6/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class FormKeyboardToolbar:UIToolbar{
  let previousButton = UIBarButtonItem(title: "Prev", style: .plain, target: nil, action: nil)
  let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: nil, action: nil)
  let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
  let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: nil)
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  func setupView(){
    sizeToFit()
    barTintColor = UIColor.groupTableViewBackground
    setItems([previousButton,nextButton,flexible,doneButton], animated: true)
    
  }
}
