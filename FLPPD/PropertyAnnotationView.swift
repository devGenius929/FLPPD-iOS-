//
//  PropertyAnnotationView.swift
//  FLPPD
//
//  Created by PC on 9/29/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class PropertyAnnotationView:MKAnnotationView{
  // data
  var price:String?
  var arv:String?
  var detailBackgroundColor = UIColor.darkgreen
  var customCalloutView: UIView?
  override var annotation: MKAnnotation? {
    willSet { customCalloutView?.removeFromSuperview() }
  }
  
  // MARK: - life cycle
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView(){
    canShowCallout = false
  }
  
  
  func loadPersonDetailMapView() -> UIView? {
    let view = UIView()
    let priceLabel = UILabel()
    let arvLabel = UILabel()
    view.addSubview(priceLabel)
    view.addSubview(arvLabel)
    priceLabel.textColor = UIColor.white
    arvLabel.textColor = UIColor.white
    priceLabel.font = UIFont.systemFont(ofSize: 12)
    arvLabel.font = UIFont.systemFont(ofSize: 9)
    priceLabel.text = price
    arvLabel.text = arv
    priceLabel.setTopInSuperview(8, priority: UILayoutPriority(rawValue: 999))
    let priceLabelCenterXConstraint = NSLayoutConstraint(item: priceLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
    let arvLabelCenterXConstraint = NSLayoutConstraint(item: arvLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
    let arvLabelTopConstraint = NSLayoutConstraint(item: arvLabel, attribute: .top, relatedBy: .equal, toItem: priceLabel, attribute: .bottom, multiplier: 1, constant: 0)
    let width = priceLabel.intrinsicContentSize.width > arvLabel.intrinsicContentSize.width ? priceLabel.intrinsicContentSize.width + 16 : arvLabel.intrinsicContentSize.width + 16
    view.frame = CGRect(x: 0, y: 0, width: width, height: priceLabel.intrinsicContentSize.height + arvLabel.intrinsicContentSize.height + 16)
    arvLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([priceLabelCenterXConstraint,arvLabelCenterXConstraint,arvLabelTopConstraint])
    view.backgroundColor =  detailBackgroundColor
    view.layer.cornerRadius = 4
    return view
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    self.customCalloutView?.removeFromSuperview()
  }
}

