//
//  UserProfileViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/17/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

fileprivate let defaultConversationTopic = "conversation"

class UserProfileViewController: UITableViewController {

    private var user:User? = nil{
        didSet {
                self.listings?.user = self.user
                self.connections?.user = self.user
            }
    }
    internal var listings:ListingsCollectionViewController? = nil
    internal var connections:ConnectionsViewController? = nil
    @IBOutlet weak var avatar: AvatarImageView?
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var roleLabel: UIButton!
    @IBOutlet weak var aboutLabel: UITextView!
    @IBOutlet weak var areaCount: UILabel?
    @IBOutlet weak var memberDate: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var listingsCount: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    
    var areaController:AreaEditViewControllerWOButtons?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatButton.layer.cornerRadius = 5
        chatButton.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.barTintColor = UIColor(hex:0x202C39)
        updateUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    func loadUserWithId(_ id:Int){
        ClientAPI.default.getUserWithId(id) { [weak self](user, success) in
            if let user = user {
                self?.user = user
                self?.updateUI()
            }
        }
    }
    
    func updateUI(){
        if let user = user {
            userName.text = user.fullName
            locationLabel.text = user.city
            if locationLabel.text == nil || locationLabel.text!.isEmpty {
                locationLabel.isHidden = true
            }
            aboutLabel.text = user.about
            memberDate.text = user.created_at
            emailLabel.text = user.email

            if let url = URL(string:user.avatar){
                avatar?.af_setImage(withURL: url)
            }
            avatar?.setNeedsLayout()
            avatar?.layoutIfNeeded()
            
            roleLabel.layer.borderColor = UIColor.white.cgColor
            roleLabel.layer.cornerRadius = 3
            roleLabel.layer.borderWidth = 1
            roleLabel.layer.masksToBounds = true
            roleLabel.setTitle(user.role, for: .normal)
            if user.role == nil || user.role!.isEmpty {
                roleLabel.isHidden = true
            }
            updateAreas()
            chatButton.setTitle("Chat with:\(user.fullName)", for: .normal)
            avatar?.presenceIndicator.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateAreas(){
        guard let areaController = self.areaController  else {
            return
        }
        if let areas = user?.areas {
            let componets = areas.components(separatedBy: ",").filter() { !$0.isEmpty}
            areaController.areas = componets
        }
        else {
            areaController.areas = [String]()
        }
        guard let areaCount = self.areaCount else {
            return
        }
        areaCount.text = (areaController.areas.count > 0) ? "\(areaController.areas.count)" : ""
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedProperties" {
            listings = segue.destination as? ListingsCollectionViewController
        }
        if segue.identifier == "embedConnections" {
            connections = segue.destination as? ConnectionsViewController
        }
        if segue.identifier == "embedArea" {
            self.areaController = segue.destination as? AreaEditViewControllerWOButtons
            

        }
        
    }
    
    @IBAction func chatAction(_ sender: Any) {
        openChat()
    }
    
    func openChat() {
        guard let me = ClientAPI.currentUser, let buddy = self.user,
        let chatController = (UIApplication.shared.delegate as! AppDelegate).chatController else  {
            return
        }
        let ids = [me, buddy].map({ Int32($0.user_id) })
        let channel_id = ChatController.channelName(forUsedIds: ids, withTopic: defaultConversationTopic)
    
        let channel = Channel.channel(withId: channel_id, topic: defaultConversationTopic, inContext: CoreDataManager.shared.context)
        
        let chat = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "chatController") as! ChatViewController
        _ = chat.view
        if let buddy = ChatUser.user(withId: buddy.user_id, inContext: CoreDataManager.shared.context) {
            chat.buddy = buddy
        }
        else {
            chat.buddy = chatController.createUserBy(user: buddy)
        }
        chat.channel = channel
        CoreDataManager.shared.saveContext()
        self.navigationController?.pushViewController(chat, animated: true)
    }
}
