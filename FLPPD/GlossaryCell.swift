//
//  GlossaryCell.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

class GlossaryCell: UITableViewCell {

    static let cellID = "glossaryCell"
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var ItemTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        bgView.layer.shadowColor = UIColor.lightGray.cgColor
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.shadowOffset = CGSize(width: 3, height: 3)
        bgView.layer.masksToBounds = true
        self.backgroundColor = Colors.backgoundGrayColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
