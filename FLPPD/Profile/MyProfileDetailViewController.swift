//
//  MyProfileDetailViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/03/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import AVFoundation
import Photos
import KRProgressHUD


class MyProfileDetailViewController: UITableViewController {
    let imagePicker = UIImagePickerController()
    // avatar
    @IBOutlet weak var underAvatarImageView: UIImageView!
    var effect:UIVisualEffectView!
    @IBOutlet weak var avatarImageView: UIImageView!
    // user
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var roleField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    // about
    @IBOutlet weak var aboutField: UITextField!
    // areas
    var areasController:AreaEditViewController?
    @IBOutlet weak var addNewAreaButton: UIButton!
    // info
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    
    
    let roles = [
        "Wholesaler",
        "Investor",
        "Builder",
        "Remodeler",
        "Realtor",
        "Consumer",
        "Other"
        ]
    let rolesPicker = UIPickerView()

    @IBOutlet var allFields: [UITextField]!
    
    var profile = ClientAPI.currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(MyProfileDetailViewController.save))
    }
    func initUI() {
        if let url_string = profile?.avatar, let url = URL(string:url_string) {
            underAvatarImageView.af_setImage(withURL: url,
                                             placeholderImage: nil,
                                             filter: nil,
                                             progress: nil,
                                             progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: true, completion: { (response) in
                    self.avatarImageView.image = response.result.value
            })
            
        }
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width * 0.5
        avatarImageView.layer.masksToBounds = true
        let blur:UIBlurEffect = UIBlurEffect(style: .regular)
        effect = UIVisualEffectView (effect: blur)
        effect.frame = underAvatarImageView.bounds
        underAvatarImageView.addSubview(effect)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        _ = allFields.map {  $0.delegate=self }
        if let user = profile {
            updateFields(user: user)
        }
        rolesPicker.delegate = self
        rolesPicker.dataSource = self
        roleField.inputAccessoryView = rolesPicker
    }
    func updateFields(user:User) {
        firstNameField.text = user.first_name
        lastNameField.text = user.last_name
        roleField.text = user.role
        cityField.text = user.city
        aboutField.text = user.about
        emailField.text = user.email
        phoneField.text = user.phone_number
        if let areas = user.areas {
            areasController?.areas = areas.components(separatedBy: ",").filter({!$0.isEmpty})
        }
        else {
            areasController?.areas = [String]()
        }
    }
    func getUserFromFields(defaultUser user:User) -> User {

        let areas = self.areasController?.areas.joined(separator: ",")
        return User(first_name: firstNameField.text!,
                    last_name: lastNameField.text!,
                    phone_number: phoneField.text!,
                    about: aboutField.text!,
                    avatar: user.avatar,
                    created_at: user.created_at,
                    email: emailField.text!,
                    user_id: user.user_id,
                    devices: user.devices ?? [],
                    role: roleField.text ??  "Unknown",
                    city: cityField.text ?? "",
                    state: user.state,
                    areas: areas,
                    rank: user.rank,
                    hauses_sold: user.hauses_sold)
    }
    func validateFields() -> Bool {
        if !DataValidator.validName(firstNameField.text) {
            self.showAlert(title: "Save", message: "Invalid First Name", completion: {
                self.firstNameField.becomeFirstResponder()
            })
            return false
        }
        if !DataValidator.validName(lastNameField.text) {
            self.showAlert(title: "Save", message: "Invalid Last Name", completion: {
                self.lastNameField.becomeFirstResponder()
            })
            return false
        }
        if !DataValidator.validEmail(emailField.text) {
            self.showAlert(title: "Save", message: "Invalid email", completion: {
                self.emailField.becomeFirstResponder()
            })
            return false
        }
        if (!DataValidator.validPhoneNumber(value: phoneField.text?.replacingOccurrences(of: "+1 ", with: ""))) {
            self.showAlert(title: "Save", message: "Invalid phone", completion: {
                self.phoneField.becomeFirstResponder()
            })
            return false
        }
        return true
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        effect.frame = underAvatarImageView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clearAvatarAction(_ sender: Any) {
    }
    
    @IBAction func imageAction(_ sender: Any) {
        
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            self.launchPhotoLibrary()
        }
    }

    @IBAction func cameraAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.launchCamera()
        }
    }
    
    @IBAction func addAreaAction(_ sender: Any) {
        view.endEditing(true)
        let ac = UIAlertController(title: "Add Area", message: "Enter text", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.becomeFirstResponder()
        }
        let add = UIAlertAction(title: "Add", style: .default) {[unowned ac] (action) in
            let textField = ac.textFields!.first!
            if let text = textField.text {
                if !text.isEmpty {
                    self.areasController?.areas.append(text)
                    self.areasController?.collectionView?.reloadData()
                    //self.areasController?.collectionViewLayout.invalidateLayout()
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(add)
        ac.addAction(cancel)
        self.present(ac, animated: true, completion: nil)
    }
    @objc func save(){
        if profile != nil, validateFields() {
            let user = getUserFromFields(defaultUser: profile!)
            let dict = user.getDict()
            KRProgressHUD.show(withMessage: "Updating ...", completion: nil)
            ClientAPI.default.updateUser(dict, user_id: profile!.user_id, { [weak self] (user, error) in
                if let user = user {
                    KRProgressHUD.dismiss()
                    self?.profile = user
                    ClientAPI.currentUser = user
                    self?.navigationController?.popViewController(animated: true)
                }
                else if let error = error{
                    KRProgressHUD.showError(withMessage: error.localizedDescription)
                }
            })
        }
        
    }
    // navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedAreas" {
            self.areasController = segue.destination as? AreaEditViewController
            
        }
    }
    
}
// picking image
extension MyProfileDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func launchPhotoLibrary(){
        self.imagePicker.sourceType = .photoLibrary
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                if status == .authorized {
                    DispatchQueue.main.async(execute: {[unowned self]()->Void in
                        self.present(self.imagePicker, animated: true, completion: nil)
                    })
                } else {
                    self.showOpenSettingsAlert(message: "FLPPD needs permission to access your photo library to select a photo. Please go to Settings > Privacy > Photos, and enable FLLPD.")
                }
            })
        }
    }
    func launchCamera(){
        let alertMessage = "FLPPD needs permission to access your device's camera to take a photo. Please go to Settings > Privacy > Camera, and enable FLLPD."
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video){
        case .denied :
            return self.showOpenSettingsAlert(message: alertMessage)
        case .restricted:
            self.showOpenSettingsAlert(message: alertMessage)
        case .authorized:
            self.imagePicker.sourceType = .camera
            DispatchQueue.main.async(execute: {[unowned self]()->Void in
                self.present(self.imagePicker, animated: true, completion: nil)
            })
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {Void in
                self.launchCamera()
            })
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        defer {
            picker.dismiss(animated:true, completion: nil)
        }
        guard let imagePicked = info[UIImagePickerControllerEditedImage] as? UIImage, let image = imagePicked.resizedImage(toSize: CGSize(width: 300, height: 300)) else {
            return
        }
        KRProgressHUD.show(withMessage: "Uploading...", completion: nil)
        self.uploadAvatar(image, completion: {(url, error) in
            
            if let error = error {
                KRProgressHUD.dismiss()
                self.showWarningAlert(message: error.localizedDescription)
                return
            }
            else {
                KRProgressHUD.update(message: "Setting up image...")
                self.profile?.avatar = url!
                self.avatarImageView.image = image
                self.underAvatarImageView.image = image
                // update image on prev controller
                if let count = (self.navigationController?.viewControllers.count), count > 0, let prev = self.navigationController?.viewControllers[count-1] as? ProfileViewController{
                    prev.avatarImage.image = image
                }
                // place image into cache
                UIImageView().af_setImage(withURL: URL(string:url!)!)


                ClientAPI.default.updateUser(["avatar":url!], user_id: self.profile!.user_id, { (user, error) in
                    if let error = error {
                        self.showWarningAlert(message: error.localizedDescription)
                    }
                    else if let user = user {
                        self.profile = user
                        ClientAPI.currentUser = user
                    }
                    KRProgressHUD.dismiss()
                })
                
            }
            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadAvatar(_ image:UIImage, completion: @escaping (_ url_string:String?, _ error:Error?) -> Void ) {
        Helper.uploadImage(image) { (url, error) in
            let url_string = url?.absoluteString
            completion(url_string,error)
        }
    }
}

extension MyProfileDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let index = allFields.index(of: textField)!
        if index+1 < allFields.count {
            allFields[index+1].becomeFirstResponder()
        }
        else {
            view.endEditing(true)
        }
        return false
    }
}

extension MyProfileDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roleField.text = roles[row]
    }
    
    
}
