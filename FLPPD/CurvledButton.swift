//
//  CurvledButton.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/06/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
fileprivate let defaultCornerRadius:CGFloat = 5.0
class CurvledButton: UIButton {
    @IBInspectable
    var cornerRadius:CGFloat = defaultCornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = cornerRadius
    }
    override func prepareForInterfaceBuilder() {
        layer.cornerRadius = cornerRadius
    }
}
