//
//  Colors.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/18/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}


struct Colors{
  
  static let greenColor = UIColor(red: 56/255, green: 142/255, blue: 60/255, alpha: 1)
  static let darkBlue = UIColor(red: 32/255, green: 44/255, blue: 57/255, alpha: 1)
  static let goldColor = UIColor(red:0.72, green:0.69, blue:0.55, alpha:1.0)
  static let grayColor = UIColor(red:0.65, green:0.64, blue:0.66, alpha:1.0)
  static let navBlackColor = UIColor(red:0.12, green:0.17, blue:0.22, alpha:1.0)
    static let chatLeftBubbleColor = UIColor(hex:0xB8B08D)
    static let chatRightBubbleColor = UIColor.white
    static let navFont = UIColor(hex: 0xA7A2A9)
    static let backgoundGrayColor = UIColor(hex:0xf6f5f7)
  
}


