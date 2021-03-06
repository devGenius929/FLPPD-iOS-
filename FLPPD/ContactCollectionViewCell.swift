//
//  ContactCollectionViewCell.swift
//  FLPPD
//
//  Created by PC on 10/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//
import Foundation
import UIKit
import RxSwift
class ContactCollectionViewCell:UICollectionViewCell{
  let avatarView = UIImageView()
  let connectionButtion = UIButton()
  let nameLabel = UILabel()
  let separatorView = UIView()
  var disposeBag = DisposeBag()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    separatorView.isHidden = false
  }
  private func setupView(){
    contentView.addSubview(separatorView)
    contentView.addSubview(avatarView)
    contentView.addSubview(connectionButtion)
    contentView.addSubview(nameLabel)
    contentView.backgroundColor = UIColor.white
    //MARK:Separator
    separatorView.setLeadingInSuperview(15, priority: UILayoutPriority(rawValue: 999))
    separatorView.setTrailingInSuperview(-15, priority: UILayoutPriority(rawValue: 999))
    separatorView.setTopInSuperview(0.5, priority: UILayoutPriority(rawValue: 999))
    separatorView.setHeightConstraint(0.5, priority: UILayoutPriority(rawValue: 999))
    separatorView.backgroundColor = UIColor.lightGray
    //MARK:Avatar
    avatarView.setLeadingInSuperview(20, priority: UILayoutPriority(rawValue: 999))
    avatarView.centerVerticallyInSuperview()
    avatarView.setHeightConstraint(54, priority: UILayoutPriority(rawValue: 999))
    avatarView.setWidthConstraint(54, priority: UILayoutPriority(rawValue: 999))
    avatarView.layer.cornerRadius = 27
    avatarView.layer.masksToBounds = true
    connectionButtion.setHeightConstraint(29, priority: UILayoutPriority(rawValue: 999))
    connectionButtion.centerVerticallyInSuperview()
    connectionButtion.setTrailingInSuperview(-15, priority: UILayoutPriority(rawValue: 999))
    connectionButtion.setWidthConstraint(90, priority: UILayoutPriority(rawValue: 999))
    connectionButtion.layer.borderColor = UIColor.lightGray.cgColor
    connectionButtion.contentHorizontalAlignment = .center
    connectionButtion.contentVerticalAlignment = .center
    connectionButtion.layer.cornerRadius = 4
    connectionButtion.layer.masksToBounds = true
    nameLabel.setLeadingInSuperview(90, priority: UILayoutPriority(rawValue: 999))
    nameLabel.setTopInSuperview(24, priority: UILayoutPriority(rawValue: 999))
    nameLabel.font = UIFont.systemFont(ofSize: 15)
  }
  func setAsConnected(){
    let connectedFontAttribute:[NSAttributedStringKey:Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.white,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont.systemFont(ofSize: 11)]
    let attributedStr = NSAttributedString(string: "CONNECTED", attributes: connectedFontAttribute)
    connectionButtion.backgroundColor = UIColor.darkgreen
    connectionButtion.setAttributedTitle(attributedStr, for: .normal)
    connectionButtion.layer.borderWidth = 0
  }
  func setAsConnect(){
    let connectFontAttribute:[NSAttributedStringKey:Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.darkgreen,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont.systemFont(ofSize: 11)]
    connectionButtion.backgroundColor = UIColor.white
    let attributedStr = NSAttributedString(string: "CONNECT", attributes: connectFontAttribute)
    connectionButtion.setAttributedTitle(attributedStr, for: .normal)
    connectionButtion.layer.borderWidth = 0.5
  }
  func setAsPending(){
    let pendingFontAttribute:[NSAttributedStringKey:Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.darkerGold,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont.systemFont(ofSize: 11)]
    connectionButtion.backgroundColor = UIColor.white
    let attributedStr = NSAttributedString(string: "PENDING", attributes: pendingFontAttribute)
    connectionButtion.setAttributedTitle(attributedStr, for: .normal)
    connectionButtion.layer.borderWidth = 0.5
  }
}
