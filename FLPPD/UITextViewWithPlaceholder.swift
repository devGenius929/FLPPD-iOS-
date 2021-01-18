//
//  UITextViewWithPlaceholder.swift
//  FLPPD
//
//  Created by PC on 7/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class UITextViewWithPlaceholder:UITextView{
  let placeholder:Variable<String?> = Variable(nil)
  let showPlaceholder:Variable<Bool> = Variable(true)
  private let disposeBag = DisposeBag()
  private var currentTextColor:UIColor?
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  private func setupView() {
    isScrollEnabled = false
    placeholder.asObservable().subscribe(onNext:{[unowned self](placeholder)->Void in
      if self.showPlaceholder.value{
        self.showPlaceholder.value = true
      }
    }).disposed(by: disposeBag)
    showPlaceholder.asObservable().subscribe(onNext:{[unowned self](show)->Void in
      if show,let placeholder = self.placeholder.value{
        self.text = placeholder
        self.currentTextColor = self.textColor
        self.textColor = UIColor.lightGray
      }else{
        self.textColor = self.currentTextColor
      }
    }).disposed(by: disposeBag)
    
    self.rx.didBeginEditing.subscribe(onNext:{[unowned self]()->Void in
      if self.showPlaceholder.value {
        self.text = nil
        self.textColor = self.currentTextColor
      }
    }).disposed(by: disposeBag)
    self.rx.didEndEditing.subscribe(onNext:{[unowned self]()->Void in
      if self.text.isEmpty {
        self.showPlaceholder.value = true
      }else{
        self.showPlaceholder.value = false
      }
    }).disposed(by: disposeBag)
  }
}
