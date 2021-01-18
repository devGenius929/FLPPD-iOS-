//
//  AreaCell.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit


class AreaCell: UICollectionViewCell {
    internal static let labelOffset:CGFloat = 10
    internal static let buttonWidth:CGFloat = 25
    internal static let defaultCellHeight:CGFloat = 27
    class func cellID() -> String {
        return "areaCell"
    }
    var cellWidth:NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        cellWidth = self.contentView.widthAnchor.constraint(equalToConstant: 0.0)
        self.contentView.heightAnchor.constraint(equalToConstant: AreaCell.defaultCellHeight).isActive = true
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var delButton: UIButton?
    class func cellSize(withText text:String) ->CGSize {
        var size = CGSize(width: (labelOffset * 2) + buttonWidth, height: defaultCellHeight)
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = text
        let labelSize = label.sizeThatFits(CGSize(width: 10e100, height: defaultCellHeight))
        size.width += labelSize.width
        return size
    }
    func setWidht(){
        let size = AreaCell.cellSize(withText: area ?? "")
        cellWidth.constant = size.width
        cellWidth.isActive = true
    }
    var area:String? {
        didSet {
            label.text = area
            setWidht()
        }
    }
}

class AreaCellWOButton:AreaCell{
    override class func cellSize(withText text:String) -> CGSize{
        var size = super.cellSize(withText: text)
        size.width -= buttonWidth
        return size
    }
    override func setWidht(){
        let size = AreaCellWOButton.cellSize(withText: area ?? "")
        cellWidth.constant = size.width
        cellWidth.isActive = true
    }
}
