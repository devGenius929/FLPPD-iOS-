//
//  CustomSlider.swift
//  FLPPD
//
//  Created by PC on 6/17/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class CustomSlider:UIView{
  let slider = UISlider()
  let decButton = UIButton()
  let incButton = UIButton()
  let titleLabel = UILabel()
  let detailLabel = UILabel()
  let sliderValue = Variable(NSDecimalNumber.zero)
  var step:Float = 0.5
  private let disposeBag = DisposeBag()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  func setupView() {
    addSubview(slider)
    addSubview(decButton)
    addSubview(incButton)
    addSubview(titleLabel)
    addSubview(detailLabel)
    addTopSeparator(1, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    //MARK:Title label
    titleLabel.font = UIFont.systemFont(ofSize: 11)
    titleLabel.textColor = UIColor.lightGray
    titleLabel.setLeadingInSuperview(20, priority: UILayoutPriority(rawValue: 1000))
    titleLabel.setTopInSuperview(8, priority: UILayoutPriority(rawValue: 1000))
    //MARK:Detail label
    detailLabel.font = UIFont.systemFont(ofSize: 15)
    detailLabel.setLeadingInSuperview(20, priority: UILayoutPriority(rawValue: 1000))
    detailLabel.setBottomInSuperview(-8, priority: UILayoutPriority(rawValue: 1000))
    let detailLabelTopConstraint = NSLayoutConstraint(item: detailLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: -2)
    //MARK:Dec button
    decButton.setImage(UIImage(named:"decrement"), for: .normal)
    decButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
    decButton.setWidthConstraint(34, priority: UILayoutPriority(rawValue: 1000))
    decButton.centerVerticallyInSuperview()
    let decButtonRightConstraint = NSLayoutConstraint(item: decButton, attribute: .trailing, relatedBy: .equal, toItem: slider, attribute: .leading, multiplier: 1, constant: 0)
    //MARK:Inc button
    incButton.setImage(UIImage(named:"increment"), for: .normal)
    incButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
    incButton.setWidthConstraint(34, priority: UILayoutPriority(rawValue: 1000))
    incButton.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    incButton.centerVerticallyInSuperview()
    //MARK:Slider
    slider.tintColor = UIColor.darkgreen
    slider.setBottomInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    slider.setTopInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    let sliderRightConstraint = NSLayoutConstraint(item: slider, attribute: .trailing, relatedBy: .equal, toItem: incButton, attribute: .leading, multiplier: 1, constant: 0)
    slider.setWidthConstraint(160, priority: UILayoutPriority(rawValue: 1000))
    NSLayoutConstraint.activate([detailLabelTopConstraint,sliderRightConstraint,decButtonRightConstraint])
    //MARK:Setup rx
    slider.rx.value.asObservable().subscribe(onNext:{[unowned self](value)->Void in
      let roundedValue = round(value/self.step)*self.step
      self.sliderValue.value = NSDecimalNumber(value: roundedValue)
    }).disposed(by: disposeBag)
    incButton.rx.tap.subscribe(onNext:{Void in
      if self.slider.value < self.slider.maximumValue{
        self.sliderValue.value = self.sliderValue.value.adding(NSDecimalNumber(value: self.step))
      }
    }).disposed(by: disposeBag)
    decButton.rx.tap.subscribe(onNext:{Void in
      if self.slider.value > self.slider.minimumValue{
        self.sliderValue.value = self.sliderValue.value.subtracting(NSDecimalNumber(value: self.step))
      }
    }).disposed(by: disposeBag)
    sliderValue.asObservable().subscribe(onNext:{[unowned self](value)->Void in
      self.slider.value = value.floatValue
    }).disposed(by: disposeBag)
  }
}
