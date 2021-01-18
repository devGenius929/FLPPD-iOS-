//
//  MessageTableViewCell.swift
//  FLPPD
//
//  Created by Vlad Konon on 11/26/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

fileprivate let sideOffset = CGFloat(14)
fileprivate let bottomOffset = CGFloat(8)
fileprivate let textToBottomOffset = CGFloat(25)
fileprivate let topOffset = CGFloat(8)
fileprivate let minHeight = CGFloat(66)
fileprivate let textUpDownOffset = CGFloat(10)
fileprivate let textToBubbleOffset = CGFloat(12)

class MessageTableViewCell: UITableViewCell {
    static let leftId = "chatLeft"
    static let rightId = "chatRight"
    static let defaultInsets = UIEdgeInsets(top: textUpDownOffset, left: textToBubbleOffset, bottom: textUpDownOffset, right: textToBubbleOffset)
    static let textSize:CGFloat = 14
    static let fontName:String = "Arial"
    
    internal var _isLeft:Bool = false
    
    var isLeft:Bool {
        get {
            return _isLeft
        }
    }
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        _isLeft = self.reuseIdentifier == MessageTableViewCell.leftId
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        messageText.layer.cornerRadius = 5
        messageText.layer.masksToBounds = true
        messageText.textContainerInset = MessageTableViewCell.defaultInsets
        self.layer.isGeometryFlipped = true
        //messageLabel.textAlignment = _isLeft ? .left : .right
    }
    static func heightForCell(width:CGFloat, text:String?) -> CGFloat {
        let maxTextWidth = width - sideOffset*2
        let label = UITextView()
        label.textContainerInset = defaultInsets
        label.text = text
        label.font = UIFont(name: fontName, size: textSize)
        let size = label.sizeThatFits(CGSize(width: maxTextWidth, height: 10e100))
        let allHeight = size.height + bottomOffset + topOffset + textToBottomOffset
        return allHeight
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.width
        let allHeight = MessageTableViewCell.heightForCell(width: width, text: messageText.text)
        let messageHeight = allHeight - bottomOffset - topOffset - textToBottomOffset
        let maxTextWidth = width - sideOffset*2
        let size = messageText.sizeThatFits(CGSize(width: maxTextWidth, height: messageHeight))
        var frame = CGRect(x: 0, y: 0, width: size.width, height: messageHeight)
        let leftOffset = _isLeft ? sideOffset : width - sideOffset - size.width
        frame.origin.x = leftOffset
        frame.origin.y = topOffset
        messageText.frame = frame
        
        // update time position
        frame.size = timeLabel.sizeThatFits(CGSize(width: 1000, height: 1000))
        frame.origin.x = isLeft ? 26 : width - 26 - frame.size.width
        frame.origin.y = messageText.frame.maxY + 6
        timeLabel.frame = frame
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
