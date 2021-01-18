//
//  StandardFormFieldWithImageView.swift
//  FLPPD
//
//  Created by PC on 7/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class StandardFormFieldWithImageView:UIView{
  let stackView = UIStackView()
  let mainStackView = UIStackView()
  let leftLabel = UILabel()
  let cameraButton = UIButton()
  let deleteButton = UIButton()
  let image:Variable<UIImage?> = Variable(nil)
  private let disposeBag = DisposeBag()
  private let imageView = UIImageView()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  private func setupView() {
    backgroundColor = UIColor.white
    addSubview(stackView)
    stackView.axis = .vertical
    stackView.pinToSuperView()
    stackView.pinWidthToSuperview()
    stackView.addArrangedSubview(mainStackView)
    let leftPadding = UIView()
    leftPadding.setWidthConstraint(16,priority:UILayoutPriority(rawValue: 1000))
    mainStackView.addArrangedSubview(leftPadding)
    mainStackView.addArrangedSubview(leftLabel)
    mainStackView.addArrangedSubview(cameraButton)
    mainStackView.addArrangedSubview(deleteButton)
    mainStackView.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    mainStackView.pinWidthToSuperview()
    stackView.addArrangedSubview(imageView)
    
    let imageViewHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: (3/4), constant: 0)
    imageViewHeightConstraint.priority = UILayoutPriority(rawValue: 999)
    NSLayoutConstraint.activate([imageViewHeightConstraint])
    imageView.contentMode = .scaleAspectFit
    cameraButton.setImage(UIImage(named:"greenCamera"), for: .normal)
    deleteButton.setImage(UIImage(named:"trashShape"), for: .normal)
    cameraButton.setWidthConstraint(50, priority: UILayoutPriority(rawValue: 1000))
    cameraButton.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    deleteButton.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 999))
    deleteButton.setWidthConstraint(50,priority:UILayoutPriority(rawValue: 999))
    
    image.asObservable().subscribe(onNext:{[unowned self](image)->Void in
     guard let image = image else{
        self.imageView.image = nil
        self.imageView.isHidden = true
        self.deleteButton.isHidden = true
        return
      }
      self.imageView.isHidden = false
      self.imageView.image = image
      self.deleteButton.isHidden = false
    }).disposed(by: disposeBag)
  }
}
