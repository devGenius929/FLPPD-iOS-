//
//  VerticalAlignLabelText.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 4/14/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

class VerticalTopAlignLabel: UILabel {
  
  override func drawText(in rect:CGRect) {
    guard let labelText = text else {  return super.drawText(in: rect) }
    
    let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedStringKey.font: font])
    var newRect = rect
    newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height
    
    if numberOfLines != 0 {
      newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
    }
    
    super.drawText(in: newRect)
  }
  
}
