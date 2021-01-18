//
//  AvatarImageView.swift
//  FLPPD
//
//  Created by Vlad Konon on 11/30/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

class AvatarImageView: UIImageView {
    internal let presenceIndicator = UIImageView()
    var isPresent:Bool = false {
        didSet {
            presenceIndicator.isHighlighted = isPresent
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenceIndicator.image = UIImage(named: "not_present")
        presenceIndicator.highlightedImage = UIImage(named: "present")
        layoutIfNeeded()
        layer.borderWidth = 0
        layer.cornerRadius = frame.width*0.5
        layer.masksToBounds = true
    }
    override func didMoveToSuperview() {
        superview?.insertSubview(presenceIndicator, aboveSubview: self)
        setNeedsLayout()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        presenceIndicator.sizeToFit()
        let size = self.frame.size
        let angle = -Float.pi/4
        var point = CGPoint(x: CGFloat(sin(angle)) * size.width*0.5, y: CGFloat(cos(angle))*size.height*0.5)
        point.x +=  center.x
        point.y +=  center.y
        presenceIndicator.center = point
    }

}
