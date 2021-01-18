//
//  ChatViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 11/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import Foundation
import KRProgressHUD
import CoreData
import PubNub
import Filestack
import FilestackSDK

enum FileUploadError: Error {
    case cantGetData
    case fileDidnotUpdloaded
}

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, NSFetchedResultsControllerDelegate {
    
    internal let hiddenTypingIndicatorOffset:CGFloat =  -55
    @IBOutlet weak var typingInvicatorOffset: NSLayoutConstraint!
    @IBOutlet weak var avatarImageView: AvatarImageView!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewTop: NSLayoutConstraint!
    @IBOutlet weak var textViewBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomOffset: NSLayoutConstraint!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    var isTyping:Bool = false
    var context = CoreDataManager.shared.context
    let chatController = (UIApplication.shared.delegate as! AppDelegate).chatController
    var fetchedResultsController:NSFetchedResultsController<InstantMessage>! {
        didSet {
            fetchedResultsController.delegate = self
            do{
                try fetchedResultsController.performFetch()
            }
            catch{
                    dprint(error.localizedDescription)
            }
    }
    }

    internal let me:ChatUser = {
        let user = ClientAPI.currentUser!
        let context = CoreDataManager.shared.context

        guard let chatuser = ChatUser.user(withId: user.user_id, inContext: CoreDataManager.shared.context) else {
            return ChatUser.object(withProperties: ["user_id":Int32(user.user_id),
                                                    "full_name": "me",
                                                    "avatar":""],
                                   in: context)
        }
        return chatuser
    }()
    var buddy:ChatUser? {
        didSet {
            if buddy != nil {
                if avatarImageView != nil {
                    setupAvatar(buddy: buddy)
                }
                chatController?.isUserHere(user: buddy!, completion: { (result) in
                    if self.avatarImageView != nil {
                        self.avatarImageView.isHighlighted = result
                    }
                })
            }
        }
    }
    
    var channel:Channel?{
        didSet{
            if let channel = channel?.id {
                self.fetchedResultsController = getResultController(withChannel: channel)
                if let users = self.channel?.users?.array as? [ChatUser],
                    let not_me = users.first(where: {$0.user_id != self.me.user_id}) {
                        self.buddy = not_me
                }
            }
        }
    }
    func setupAvatar(buddy:ChatUser?)  {
        buddy?.loadAvatar(forImageView: avatarImageView)
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width*0.5
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.masksToBounds = true
        avatarImageView.presenceIndicator.isHighlighted = buddy?.presence ?? false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.isGeometryFlipped = true
        messageText.layer.borderColor = UIColor.lightGray.cgColor
        messageText.layer.cornerRadius = 5
        messageText.layer.borderWidth = 1
        messageText.layer.masksToBounds = true
        messageText.delegate = self
        messageText.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.hideKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        avatarImageView.presenceIndicator.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
        setupAvatar(buddy: buddy)
    }
    private func getResultController(withChannel channel:String) -> NSFetchedResultsController<InstantMessage> {
        let request:NSFetchRequest<InstantMessage> = InstantMessage.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "channel_id == \"\(channel)\"")
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        chatController?.history(forChannel: channel)
        chatController?.client?.subscribeToChannels([channel], withPresence: true)
        return controller;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        observeTypingIndicator()
    }
    override func viewWillLayoutSubviews() {
        avatarImageView.setNeedsLayout()
        avatarImageView.layoutIfNeeded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        updateTyping(false)
        chatController?.client?.unsubscribeFromChannels([channel!.id!], withPresence: true)
        
    }
    func getKeyboardInfo(info:[AnyHashable:Any]) -> (UIViewAnimationCurve, Double, CGSize){
        //  Getting keyboard animation.
        var _animationCurve:UIViewAnimationCurve = .easeOut
        if let curve = (info[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue {
            _animationCurve = UIViewAnimationCurve(rawValue:curve) ?? .easeOut
        }
        //  Getting keyboard animation duration
        var _animationDuration:Double = 0.25
        if let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            
            //Saving animation duration
            if duration != 0.0 {
                _animationDuration = duration
            }
        }
        var _kbSize = CGSize()
        if let kbFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let screenSize = UIScreen.main.bounds
            //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
            let intersectRect = kbFrame.intersection(screenSize)
            
            if intersectRect.isNull {
                _kbSize = CGSize(width: screenSize.size.width, height: 0)
            } else {
                _kbSize = intersectRect.size
            }
        }
        return (_animationCurve, _animationDuration, _kbSize)
    }
    @objc func showKeyboard(_ note:Notification){
        if let info = (note as NSNotification?)?.userInfo {
            let (_animationCurve, _animationDuration, _kbSize) = getKeyboardInfo(info: info)
            UIView.setAnimationCurve(_animationCurve)
            UIView.animate(withDuration: _animationDuration, animations:{[unowned self] in
                self.bottomOffset.constant = -_kbSize.height
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            } )
        }
    }
    @objc func hideKeyboard(_ note:Notification){
        if let info = (note as NSNotification?)?.userInfo {
            let (_animationCurve, _animationDuration, _) = getKeyboardInfo(info: info)
            UIView.setAnimationCurve(_animationCurve)
            UIView.animate(withDuration: _animationDuration, animations:{[unowned self] in
                self.bottomOffset.constant = 0
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            } )
        }
    }
    var lastTimeType = Date().timeIntervalSinceReferenceDate
    func textViewDidChange(_ textView: UITextView) {
        let frame = textView.frame
        var size = textView.sizeThatFits(CGSize(width: frame.width, height: 10000))
        size.height = min(size.height, tableView.frame.height * 0.5)
        size.height = max(size.height, 39)
        bottomHeight.constant = size.height + textViewTop.constant + textViewBottom.constant
        if !textView.text.isEmpty {
            updateTyping(true)
            lastTimeType = Date().timeIntervalSinceReferenceDate
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                let diff = Date().timeIntervalSinceReferenceDate - self.lastTimeType
                if diff >= 2.9 {
                    self.updateTyping(false)
                }
            })
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            if  !textView.text.isEmpty{
                self.postMessage(text: textView.text)
                DispatchQueue.main.async {
                    self.messageText.text = ""
                    self.textViewDidChange(textView)
                }
                return false
            }
            else {
                textView.resignFirstResponder()
            }
            updateTyping(false)
        }
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
        userNameLabel.text = buddy?.full_name
        subjectLabel.text = channel?.topic
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .default
        updateTyping(false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    func observeTypingIndicator(){
        // TODO: subscrube to typing indicator for this channel
        chatController?.client?.addListener(self)
        chatController?.client?.subscribeToPresenceChannels([channel!.id!])
    }
    func showTyping(_ typing:Bool){
        if isTyping != typing {
            isTyping = typing
            UIView.animate(withDuration: 0.2, animations: {
                self.typingInvicatorOffset.constant = self.isTyping ? 0 : self.hiddenTypingIndicatorOffset
                self.view.setNeedsLayout()
                self.view.layoutSubviews()
            })
        }
    }
    internal var boolLastTyping = false
    func updateTyping(_ typing:Bool){
        if boolLastTyping != typing {
            self.boolLastTyping = typing
            chatController?.client?.setState(["isTyping":typing],
                                            forUUID: "\(me.user_id)",
                onChannel: channel!.id!,
                withCompletion: { (status) in
                    dprint("status: \(status.data)")
            })
        }
    }
    // MARK: - post message
    internal func postMessage(text:String?, imageURL:URL? = nil, image:UIImage? = nil){
        let msg = InstantMessage.instantMessage(text: text, image: image, imageURL: imageURL?.absoluteString, forUserID: Int(me.user_id), inChannel: self.channel!.id!, inContext:context)
        msg.viewed = true
        msg.sender = me
        chatController?.publishMessage(forChannel: channel!, message: msg, context: self.context)
        //try? self.fetchedResultsController.performFetch()
    }
    // MARK: - table view
    internal let timeFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()
    func formatTimeStamp(timestamp:Int64) -> String {
        return timeFormatter.string(from: Date(timeIntervalSince1970: Double(timestamp)/timeMultipler))
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = fetchedResultsController.object(at: indexPath)
        guard let frame = UIApplication.shared.delegate?.window??.frame else {
            return 88
        }
        if let _ = message.image_url {
            return 200
        }
        else {
            return MessageTableViewCell.heightForCell(width:frame.width, text: message.message)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchedResultsController.object(at: indexPath)
        var id = ""
        let file:String? = message.image_url
        if file != nil  {
            id = message.own ? ImageTableViewCell.rightId : ImageTableViewCell.leftId
        }
        else {
            id = message.own ? MessageTableViewCell.rightId : MessageTableViewCell.leftId
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        if file != nil {
            let _cell = cell as! ImageTableViewCell
            _cell.timeLabel.text = formatTimeStamp(timestamp: message.time)
            if let url = URL(string:file!) {
                _cell.iconImageView.af_setImage(withURL: url)
            }
        }
        else {
            let _cell = cell as! MessageTableViewCell
            _cell.messageText.text = message.message
            _cell.timeLabel.text = formatTimeStamp(timestamp: message.time)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let message = fetchedResultsController.object(at: indexPath)
        if !message.viewed {
            message.viewed = true
            fetchedResultsController.delegate = nil
            try? context.save()
            fetchedResultsController.delegate = self
        }
    }
    // fetched controller
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    // 2
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        self.showTyping(false)
    }
    // 3

    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    // 4
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
                let message = controller.object(at: indexPath) as! InstantMessage
                if message.isNew {
                    Sounds.default.playSound()
                }
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    // 5
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else { return nil }
        return sections[section].indexTitle ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    // MARK: - Navigation
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension ChatViewController: PNObjectEventListener {
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        if event.data.presence.uuid != client.uuid(){
            if event.data.presenceEvent == "state-change" {
                if let isTyping = event.data.presence.state?["isTyping"] as? Bool {
                    showTyping(isTyping)
                }
            }
            else {
                if let id = buddy?.user_id, event.data.presence.uuid == "\(id)" {
                    let presenceEvent =  event.data.presenceEvent
                    if  presenceEvent == "join" {
                        buddy?.presence = true
                    }
                    else if presenceEvent == "timeout" || presenceEvent == "leave"{
                        buddy?.presence = false
                    }
                    avatarImageView.presenceIndicator.isHighlighted = buddy?.presence ?? false
                    CoreDataManager.shared.saveContext()
                }
            }
        }
    }
    func client(_ client: PubNub, didReceive status: PNStatus) {
    }
}

extension ChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            Helper.uploadImage(image, completion: { (url, error) in
                if let error = error {
                    self.showWarningAlert(message: error.localizedDescription)
                    return
                }
                if let url = url {
                    self.postMessage(text: nil, imageURL: url, image:  image)
                }
            })
        }
        picker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    /*
    @IBAction func photoAction(_ sender:Any){
        if let picker = AppDelegate.getPicker() {
            picker.pickerDelegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }*/
    /*
    @IBAction func photoAction(_ sender:Any){
        if let client = AppDelegate.fileStackClient {
            _ = client.uploadFromDocumentPicker(viewController: self.navigationController!, uploadProgress: { (progress) in
                // Here you may update the UI to reflect the upload progress.
                dprint("progress = \(String(describing: progress))")
                let percent = round(Double(progress.completedUnitCount)/Double(progress.totalUnitCount) * 1000.0) / 10.0
                KRProgressHUD.update(message:"\(percent)%")
            }) { (response) in
                KRProgressHUD.dismiss()
                // Try to obtain Filestack handle
                if let json = response?.json, let url_string = json["url"] as? String, let url = URL(string:url_string) {
                    // Use Filestack handle
                    //self.postMessage(text: nil, imageURL: url, image:  image)
                } else if let error = response?.error {
                    // Handle error
                    KRProgressHUD.showError(withMessage: error.localizedDescription)
                }
            }
        }
    }
    */
    @IBAction func photoAction(_ sender: Any) {
        let alert = UIAlertController(title: "Post an image", message: "Choose", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.shootPhoto()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
            self.photoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func photoFromLibrary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }
    
    func shootPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        } else {
            self.showWarningAlert(message: "No camera!")
        }
    }
    
}

extension ChatViewController:PickerNavigationControllerDelegate{
    
    /// Called when the picker finishes storing a file originating from a cloud source in the destination storage location.
    func pickerStoredFile(picker: PickerNavigationController, response: StoreResponse) {
        
        if let contents = response.contents {
            // Our cloud file was stored into the destination location.
            dprint("Stored file response: \(contents)")
            AppDelegate.getPicker()?.dismiss(animated: true, completion: nil)
        } else if let error = response.error {
            // The store operation failed.
            dprint("Error storing file: \(error)")
        }
    }
    
    /// Called when the picker finishes uploading a file originating from the local device in the destination storage location.
    func pickerUploadedFile(picker: PickerNavigationController, response: NetworkJSONResponse?) {
        
        if let contents = response?.json {
            // Our local file was stored into the destination location.
            dprint("Uploaded file response: \(contents)")
            AppDelegate.getPicker()?.dismiss(animated: true, completion: nil)
            // TODO: save file
        } else if let error = response?.error {
            // The upload operation failed.
            dprint("Error uploading file: \(error)")
        }
    }
}
