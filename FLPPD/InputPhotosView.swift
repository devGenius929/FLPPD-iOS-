//
//  InputPhotosView.swift
//  FLPPD
//
//  Created by PC on 5/4/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class InputPhotosView:UIView{
  @IBOutlet weak var view: UIStackView!
  @IBOutlet weak var rightView: UIView!
  @IBOutlet weak var leftView: UIView!
  @IBOutlet weak var useCameraTap: UITapGestureRecognizer!
  @IBOutlet weak var fromFileTap: UITapGestureRecognizer!
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    let bundle = Bundle(for: type(of: self))
    UINib(nibName: "InputPhotosView", bundle: bundle).instantiate(withOwner: self, options: nil)
    addSubview(view)
    view.pinToSuperView()
    leftView.addRightSeparator(0.5, topInset: 20, bottomInset: 20, color: UIColor.lightGray)
  }
}
