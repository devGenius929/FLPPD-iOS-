//
//  EvalPropertyAnnotationView.swift
//  FLPPD
//
//  Created by PC on 5/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class EvalPropertyAnnotationView:PropertyAnnotationView{
  // MARK: - callout showing and hiding
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
      self.customCalloutView?.removeFromSuperview()
      if let newCustomCalloutView = loadPersonDetailMapView() {
        // fix location from top-left to its right place.
        newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
        newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height - 10
        
        // set custom callout view
        self.addSubview(newCustomCalloutView)
        self.customCalloutView = newCustomCalloutView
        
        // animate presentation
        if animated {
          self.customCalloutView!.alpha = 0.0
          UIView.animate(withDuration: 0.1, animations: {
            self.customCalloutView!.alpha = 1.0
          })
        }
      }
    } else {
      if customCalloutView != nil {
        if animated { // fade out animation, then remove it.
          UIView.animate(withDuration: 0.1, animations: {
            self.customCalloutView!.alpha = 0.0
          }, completion: { (success) in
            self.customCalloutView!.removeFromSuperview()
          })
        } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
      }
    }
  }
}
