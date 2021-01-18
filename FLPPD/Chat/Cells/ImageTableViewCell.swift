//
//  FileTableViewCell.swift
//  FLPPD
//
//  Created by Vlad Konon on 11/28/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    static let leftId = "imageLeft"
    static let rightId = "imageRight"
    internal var _isLeft:Bool = false
    var isLeft:Bool {
        get {
            return _isLeft
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _isLeft = self.reuseIdentifier == MessageTableViewCell.leftId
    }
    override func didMoveToSuperview() {
        iconImageView.image = nil
        self.layer.isGeometryFlipped = true
        self.iconImageView.layer.cornerRadius = 8
        self.iconImageView.layer.masksToBounds = true
        self.iconImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.iconImageView.layer.borderWidth = 0.5
    }
    
}
