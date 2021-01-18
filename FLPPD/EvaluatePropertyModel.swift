//
//  EvaluatePropertyModel.swift
//  FLPPD
//
//  Created by PC on 6/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
func bindPropertyStringAttribute(_ property:Property,textField:UITextField,keyPath:String,saveEmpty:Bool,disposeBag:DisposeBag){
  textField.rx.controlEvent([.editingDidEnd]).subscribe(onNext:{Void in
    if !saveEmpty,textField.text == nil,(textField.text?.isEmpty)!{
      let string = property.value(forKeyPath: keyPath) as? String
      textField.text = string
      return
    }
    property.setValue(textField.text, forKeyPath: keyPath)
  }).disposed(by: disposeBag)
  
}
