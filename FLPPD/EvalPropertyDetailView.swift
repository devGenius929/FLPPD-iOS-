//
//  EvalPropertyDetailView.swift
//  FLPPD
//
//  Created by PC on 5/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EvalPropertyDetailView:UIScrollView{
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var propertyMainView: UIView!
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var streetAddressLabel: UILabel!
   @IBOutlet weak var cityStateLabel: UILabel!
   @IBOutlet weak var priceLabel: UILabel!
  //views
  @IBOutlet weak var worksheetView: UIView!
  
  @IBOutlet weak var mapView: UIView!
  @IBOutlet weak var analysisView: UIView!
  @IBOutlet weak var projectionsView: UIView!
  @IBOutlet weak var reportView: UIView!
  @IBOutlet weak var upgradeToProView: UIView!
  //taps

    @IBOutlet weak var propertyMainViewTap: UITapGestureRecognizer!
  @IBOutlet weak var worksheetCellTap: UITapGestureRecognizer!
  @IBOutlet weak var mapCellTap: UITapGestureRecognizer!
  @IBOutlet weak var summaryAnalysisCellTap: UITapGestureRecognizer!
  @IBOutlet weak var projectionsCellTap: UITapGestureRecognizer!
  @IBOutlet weak var reportCellTap: UITapGestureRecognizer!
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var upgradeButton2: UIButton!
    @IBOutlet weak var reporstLabel: UILabel!
    @IBOutlet weak var lockReport: UIImageView!
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
    func setupReport(enabled:Bool) {
        if enabled {
            lockReport.isHighlighted = false
            reporstLabel.textColor = UIColor.black
            reportCellTap.isEnabled = true
            upgradeToProView.isHidden = true
            upgradeButton.isHidden = true
            upgradeButton2.isHidden = true
        }
        else {
            lockReport.isHighlighted = true
            reporstLabel.textColor = UIColor(hex: 0xD8D8D8)
            reportCellTap.isEnabled = false
            upgradeToProView.isHidden = false
            upgradeButton.isHidden = false
            upgradeButton2.isHidden = false
        }
    }
  private func setupView(){
    let bundle = Bundle(for: type(of: self))
     UINib(nibName: "EvalPropertyDetailView", bundle: bundle).instantiate(withOwner: self, options: nil)
    addSubview(stackView)
    self.backgroundColor = UIColor.groupTableViewBackground
    stackView.pinToSuperView()
    let widthConstraint = NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
    NSLayoutConstraint.activate([widthConstraint])
    propertyMainView.layer.cornerRadius = 4
    let viewsWithNoLeftInsetSeparator:[UIView] = [worksheetView, separatorView]//upgradeToProView
    for view in viewsWithNoLeftInsetSeparator{
      view.addTopSeparator(0.5, rightInset: 0, leftInset: 0, color: UIColor.lightGray)
    }
    let viewsWithLeftInsetSeparator:[UIView] = [mapView,analysisView,projectionsView,reportView]
    for view in viewsWithLeftInsetSeparator{
      view.addTopSeparator(0.5, rightInset: 0, leftInset: 20, color: UIColor.lightGray)
    }
    setupReport(enabled: InAppPurchasesController.default.proSubsciptionIsActive)
  }
}
