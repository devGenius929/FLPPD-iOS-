//
//  CustomPrintRenderer.swift
//  FLPPD
//
//  Created by PC on 7/18/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
class CustomPrintRenderer:UIPrintPageRenderer{
  let A4PageWidth: CGFloat = 595.2
  let A4PageHeight: CGFloat = 841.8
  override init() {
    super.init()
    
    // Specify the frame of the A4 page.
    let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
    
    // Set the page frame.
    setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
    
    // Set the horizontal and vertical insets (that's optional).
    setValue(NSValue(cgRect: pageFrame.insetBy(dx: 10.0, dy: 10.0)), forKey: "printableRect")
  }
}
