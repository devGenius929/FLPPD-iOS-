//
//  ImageViewWithButton.swift
//  FLPPD
//
//  Created by PC on 5/10/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class ImageViewWithButton:UIImageView{
  let button = UIButton()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  override init(image: UIImage?) {
    super.init(image: image)
    setupView()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  private func setupView(){
    addSubview(button)
    contentMode = .scaleAspectFill
    clipsToBounds = true
    
    //setup button
    button.pinToSuperViewTopRightCorner(6, rightMargin: 6)
    button.setImage(UIImage(named:"delete"), for: .normal)
    button.setWidthConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    button.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    self.isUserInteractionEnabled = true
    
  }
}
