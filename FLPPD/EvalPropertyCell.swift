//
//  EvalPropertyCell.swift
//  FLPPD
//
//  Created by PC on 5/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit

class EvalPropertyCell:UITableViewCell{
  
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var cityStateLabel: UILabel!
  @IBOutlet weak var streetAddressLabel: UILabel!
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var priceLabel: UILabel!
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  private func setupView(){
    let bundle = Bundle(for: type(of: self))
    UINib(nibName: "EvalPropertyCell", bundle: bundle).instantiate(withOwner: self, options: nil)
    contentView.addSubview(mainView)
    self.backgroundColor = UIColor.clear
    self.contentView.backgroundColor = UIColor.clear
    mainView.layer.cornerRadius = 4
    let mainViewTopConstraint = NSLayoutConstraint(item: mainView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 4)
    let mainViewBottomConstraint = NSLayoutConstraint(item: mainView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -4)
    let mainViewLeadingConstraint = NSLayoutConstraint(item: mainView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 4)
    let mainViewTrailingConstraint = NSLayoutConstraint(item: mainView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -4)
    mainView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([mainViewTopConstraint,mainViewBottomConstraint,mainViewLeadingConstraint,mainViewTrailingConstraint])
  }
}
