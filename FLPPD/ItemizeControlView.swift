//
//  ItemizeControlView.swift
//  FLPPD
//
//  Created by PC on 5/25/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class ItemizeControlView:UIView{
  private let controlView = UIStackView()
  let addButton = UIButton()
  let editButton = UIButton()
  let rearrangeButton = UIButton()
  let deleteButton = UIButton()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    backgroundColor = UIColor.clear
    addSubview(controlView)
    controlView.pinToSuperView()
    controlView.distribution = .fillEqually
    addButton.setImage(UIImage(named:"add"), for: .normal)
    editButton.setImage(UIImage(named:"edit"), for: .normal)
    rearrangeButton.setImage(UIImage(named:"rearrange"), for: .normal)
    deleteButton.setImage(UIImage(named:"trash"), for: .normal)
    controlView.addArrangedSubview(addButton)
    controlView.addArrangedSubview(editButton)
    controlView.addArrangedSubview(rearrangeButton)
    controlView.addArrangedSubview(deleteButton)
  }
}
