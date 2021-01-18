//
//  ImageViewPopup.swift
//  FLPPD
//
//  Created by Vlad Konon on 11/29/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit


class ImageViewPopup: UIImageView {
    var temporaryRect: CGRect?
    var backgroundView: UIView!
    
    var animated: Bool = true
    var duration = 0.25
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTapRecognizer()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTapRecognizer()
    }
    internal func addTapRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageViewPopup.popUpImageToFullScreen))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    @objc func exitFullScreen () {
        let imageV = backgroundView.subviews[0] as! UIImageView
        
        UIView.animate(withDuration: duration, animations: {
            imageV.frame = self.temporaryRect!
            self.backgroundView.alpha = 0
        }, completion: { _ in
            self.backgroundView.removeFromSuperview()
        })
    }
    
    @objc func popUpImageToFullScreen() {

        if let window = UIApplication.shared.delegate?.window {
            let parentView = self.findParentViewController(self)!.view
            parentView?.endEditing(true)
            backgroundView = UIView(frame: UIScreen.main.bounds)
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ImageViewPopup.exitFullScreen)))
            backgroundView.alpha = 0
            backgroundView.backgroundColor = UIColor.black
            let imageV = UIImageView(image: self.image)
            let point = self.convert(self.bounds, to: parentView)
            imageV.frame = point
            temporaryRect = point
            imageV.contentMode = .scaleAspectFit
            self.backgroundView.addSubview(imageV)
            window?.addSubview(backgroundView)
            
            if animated {
                UIView.animate(withDuration: duration, animations: {
                    self.backgroundView.alpha = 1
                    imageV.frame = CGRect(x: 0, y: 0, width: (parentView?.frame.width)!, height: (parentView?.frame.width)!)
                    imageV.center = (parentView?.center)!
                })
            }
        }
    }
    
    func findParentViewController(_ view: UIView) -> UIViewController? {
        return AppDelegate.current.window?.rootViewController
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
