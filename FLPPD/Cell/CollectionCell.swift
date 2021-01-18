//
//  CollectionCell.swift
//  FLPPD
//
//  Created by Vlad Konon on 01/11/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import Alamofire

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var avatar: AvatarImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        avatar.image = #imageLiteral(resourceName: "My Team")
        nameLabel.text = "-"
        countLabel.text = "0"
        titleLabel.text = "mutual connections"
    }
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.masksToBounds = true
        avatar.presenceIndicator.isHidden = true
    }
    func configureCell( user:UserAndMutuals) {
        nameLabel.text = user.user.fullName
        countLabel.text = "\(user.mutualFriends)"
        titleLabel.text = user.mutualFriends != 1 ? "mutual connections" : "mutual connection"
        if let url = URL(string: user.user.avatar) {
            avatar.af_setImage(withURL:url)
        }
       
    }
}
