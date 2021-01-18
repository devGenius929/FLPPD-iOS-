//
//  BorderButton.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/8/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

// MARK: - BorderedButton: Button

class GoldenBorderButton: UIButton {
  
  // MARK: Properties
  
  // constants for styling and configuration
  let darkerGold = UIColor(red:0.72, green:0.69, blue:0.55, alpha:1.0)
  let lighterGold = UIColor(red:0.72, green:0.69, blue:0.55, alpha:0.4)
  let titleLabelFontSize: CGFloat = 17.0
  let borderedButtonHeight: CGFloat = 44.0
  let borderedButtonCornerRadius: CGFloat = 4.0
  let phoneBorderedButtonExtraPadding: CGFloat = 14.0
  
  var backingColor: UIColor? = nil
  var highlightedBackingColor: UIColor? = nil
  
  // MARK: Initialization
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    themeBorderedButton()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    themeBorderedButton()
  }
  
  func opacity(_ value: Bool){
    if value == true{
      self.alpha = 1
    }else{
      self.alpha = 0.5
    }
  }
  
  private func themeBorderedButton() {
    layer.masksToBounds = true
    layer.cornerRadius = borderedButtonCornerRadius
    layer.borderWidth = 1
    layer.borderColor = darkerGold.cgColor
    highlightedBackingColor = darkerGold
    backingColor = lighterGold
    backgroundColor = lighterGold
    setTitleColor(.white, for: UIControlState())
    titleLabel?.font = UIFont.systemFont(ofSize: titleLabelFontSize)
  }
  
  // MARK: Setters
  
  private func setBackingColor(_ newBackingColor: UIColor) {
    if let _ = backingColor {
      backingColor = newBackingColor
      backgroundColor = newBackingColor
    }
  }
  
  private func setHighlightedBackingColor(_ newHighlightedBackingColor: UIColor) {
    highlightedBackingColor = newHighlightedBackingColor
    backingColor = highlightedBackingColor
  }
  
  // MARK: Tracking
  
  override func beginTracking(_ touch: UITouch, with withEvent: UIEvent?) -> Bool {
    backgroundColor = highlightedBackingColor
    return true
  }
  
  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    backgroundColor = backingColor
  }
  
  override func cancelTracking(with event: UIEvent?) {
    backgroundColor = backingColor
  }
  
  // MARK: Layout
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let extraButtonPadding : CGFloat = phoneBorderedButtonExtraPadding
    var sizeThatFits = CGSize.zero
    sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
    sizeThatFits.height = borderedButtonHeight
    return sizeThatFits
  }
}

