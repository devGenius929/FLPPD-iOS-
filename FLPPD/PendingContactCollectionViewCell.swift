//
//  PendingContactCollectionViewCell.swift
//  FLPPD
//
//  Created by PC on 10/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class PendingContactCollectionViewCell:UICollectionViewCell{
  private let mainView = UIView()
  private let messageLabel = UILabel()
  let avatarView = UIImageView()
  let acceptButton = UIButton()
  let rejectButton = UIButton()
  let nameLabel = UILabel()
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
  }
  private func setupView(){
    //MARK:Content view
    contentView.addSubview(mainView)
    //MARK:Main view
    mainView.addSubview(avatarView)
    mainView.addSubview(messageLabel)
    mainView.addSubview(acceptButton)
    mainView.addSubview(rejectButton)
    mainView.addSubview(nameLabel)
    mainView.setLeadingInSuperview(14, priority: UILayoutPriority(rawValue: 999))
    mainView.setTrailingInSuperview(-14, priority: UILayoutPriority(rawValue: 999))
    mainView.setTopInSuperview(14, priority: UILayoutPriority(rawValue: 999))
    mainView.setBottomInSuperview(-14, priority: UILayoutPriority(rawValue: 999))
    mainView.backgroundColor = UIColor.white
    mainView.layer.cornerRadius = 4
    avatarView.setLeadingInSuperview(20, priority: UILayoutPriority(rawValue: 999))
    avatarView.setTopInSuperview(20, priority: UILayoutPriority(rawValue: 999))
    avatarView.setHeightConstraint(54, priority: UILayoutPriority(rawValue: 999))
    avatarView.setWidthConstraint(54, priority: UILayoutPriority(rawValue: 999))
    avatarView.layer.cornerRadius = 27
    avatarView.layer.masksToBounds = true
    //MARK:Reject button
    let rejectButtonWidthContraint = NSLayoutConstraint(item: rejectButton, attribute: .width, relatedBy: .equal, toItem: mainView, attribute: .width, multiplier: 0.5, constant: -30)
    let rejectFontAttribute:[NSAttributedStringKey:Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.darkRed,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont.systemFont(ofSize: 13)]
    let acceptFontAttribute:[NSAttributedStringKey:Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.white,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont.systemFont(ofSize: 13)]
    rejectButton.setHeightConstraint(45, priority: UILayoutPriority(rawValue: 999))
    rejectButton.setBottomInSuperview(-14, priority: UILayoutPriority(rawValue: 999))
    rejectButton.layer.borderColor = UIColor.lightGray.cgColor
    rejectButton.contentHorizontalAlignment = .center
    rejectButton.contentVerticalAlignment = .center
    rejectButton.layer.cornerRadius = 4
    rejectButton.layer.borderColor = UIColor.lightGray.cgColor
    rejectButton.layer.borderWidth = 0.5
    rejectButton.setLeadingInSuperview(15, priority: UILayoutPriority(rawValue: 999))
    let rejectButtonTitle = NSAttributedString(string: "REJECT", attributes: rejectFontAttribute)
    rejectButton.setAttributedTitle(rejectButtonTitle, for: .normal)
    //MARK:Accept button
    let acceptButtonWidthContraint = NSLayoutConstraint(item: acceptButton, attribute: .width, relatedBy: .equal, toItem: mainView, attribute: .width, multiplier: 0.5, constant: -30)
    acceptButton.setHeightConstraint(45, priority: UILayoutPriority(rawValue: 999))
    acceptButton.setBottomInSuperview(-14, priority: UILayoutPriority(rawValue: 999))
    acceptButton.backgroundColor = UIColor.darkgreen
    acceptButton.layer.borderColor = UIColor.lightGray.cgColor
    acceptButton.contentHorizontalAlignment = .center
    acceptButton.contentVerticalAlignment = .center
    acceptButton.layer.cornerRadius = 4
    let acceptButtonTitle = NSAttributedString(string: "ACCEPT", attributes: acceptFontAttribute)
    acceptButton.setAttributedTitle(acceptButtonTitle, for: .normal)
    acceptButton.setTrailingInSuperview(-15, priority: UILayoutPriority(rawValue: 999))
    NSLayoutConstraint.activate([rejectButtonWidthContraint,acceptButtonWidthContraint])
    //MARK:Name label
    nameLabel.setLeadingInSuperview(90, priority: UILayoutPriority(rawValue: 999))
    nameLabel.setTopInSuperview(45, priority: UILayoutPriority(rawValue: 999))
    nameLabel.font = UIFont.systemFont(ofSize: 15)
    nameLabel.textColor = UIColor.lightGray
    //MARK:Message label
    messageLabel.setTopInSuperview(20, priority: UILayoutPriority(rawValue: 999))
    messageLabel.setLeadingInSuperview(90, priority: UILayoutPriority(rawValue: 999))
    messageLabel.text = "Connection request from"
    messageLabel.textColor = UIColor.lightGray
    messageLabel.font = UIFont.systemFont(ofSize: 15)
  }
}
