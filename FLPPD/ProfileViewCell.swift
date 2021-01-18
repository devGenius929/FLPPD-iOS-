//
//  ProfileViewCell.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/03/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {

    static let cellId = "profileCell"
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    var count:String? = nil {
        didSet{
            countLabel.text = count
            countLabel.isHidden = count == nil
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        countLabel.layer.cornerRadius = countLabel.frame.height * 0.5
        countLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        count = nil
        iconImageView.image = nil
        titleLabel.text = nil
    }
    func configureCell(profileData:ProfileTableData) {
        count = profileData.count
        iconImageView.image = profileData.image
        titleLabel.text = profileData.text
    }

}
