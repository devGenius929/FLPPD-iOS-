//
//  ChatTableViewCell.swift
//  FLPPD
//
//  Created by Vlad Konon on 11/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    static let cellId = "ChatCell"
    static let  dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()
    var channel:Channel? = nil
    @IBOutlet weak var avatar: AvatarImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        channel = nil
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard let channel = self.channel, let currentUserId = ClientAPI.currentUser?.user_id else {
            return
        }
        if let buddy = channel.users?.array.map({ $0 as! ChatUser}).first(where: { $0.user_id != currentUserId}) {
            avatar.presenceIndicator.isHighlighted = buddy.presence
        }
    }
    func configureCell(currentUserId:Int32, channel:Channel){
        self.channel = channel
        Address.text = channel.topic
        avatar.image = #imageLiteral(resourceName: "tabIconProfile")
        avatar.layer.cornerRadius  = avatar.frame.size.height*0.5
        avatar.layer.masksToBounds = true
        time.text = nil
        lastMessage.text  = nil
        name.text = nil
        if let buddy = channel.users?.array.map({ $0 as! ChatUser}).first(where: { $0.user_id != currentUserId}) {
            name.text = buddy.full_name
            buddy.loadAvatar(forImageView: avatar)
            avatar.presenceIndicator.isHidden = false
            avatar.presenceIndicator.isHighlighted = buddy.presence
        }
        guard let recentMessage = channel.recentMessage else {
            return
        }
        lastMessage.text  = recentMessage.message
        let ti = TimeInterval(recentMessage.time) / timeMultipler
        time.text = ChatTableViewCell.dateFormatter.string(from: Date(timeIntervalSince1970: ti))


    }
    
}
