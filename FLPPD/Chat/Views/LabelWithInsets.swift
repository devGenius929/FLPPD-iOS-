//
//  LabelWithInsets.swift
//  FLPPD
//
//  Created by Vlad Konon on 11/30/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

class LabelWithInsets: UILabel {
    public var insets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, self.insets))
    }

}
