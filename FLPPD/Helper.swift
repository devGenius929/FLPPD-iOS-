//
//  Helper.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 1/20/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import Filestack

func dprint(_ items: Any..., separator: String = " ", terminator: String = "\n", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let stringItem = items.map {"\($0)"} .joined(separator: separator)
        Swift.print(stringItem, terminator: terminator)
    #endif
}

class Helper{
    
  class func navigationWhiteStyle(_ navBar: UINavigationBar){
    
    navBar.backgroundColor = UIColor.white
    navBar.setBackgroundImage(UIImage(), for: .default)
    navBar.shadowImage = UIImage()
    navBar.isOpaque = true
    navBar.isTranslucent = false
    UIApplication.shared.statusBarStyle = .default
    
  }
  
  class func navigationClearStyle(_ navController: UINavigationController){
    navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navController.navigationBar.shadowImage = UIImage()
    navController.navigationBar.isTranslucent = true
    navController.view.backgroundColor = .clear
  }
  
  class func navigationClearDetailVIew(_ navBar: UINavigationBar){
    navBar.setBackgroundImage(UIImage(), for: .default)
    navBar.shadowImage = UIImage()
    navBar.isTranslucent = true
    navBar.backgroundColor = .clear
  }
  
  
  class func navigationWithGray(_ navBar: UINavigationBar){
    
    //navbar appearance setup
    navBar.shadowImage = UIImage()
    navBar.barTintColor = UIColor.white
    navBar.tintColor = Colors.grayColor
    navBar.isTranslucent = false
    UIApplication.shared.statusBarStyle = .default
  }
    class func uploadImage(_ image:UIImage, completion:@escaping (_ url:URL?, _ error:Error?) -> Void){
        if let client = AppDelegate.fileStackClient {
            let file = UUID().uuidString.appending(".jpg")
            let fileName = FileManager.default.temporaryDirectory.appendingPathComponent(file)
            try? UIImageJPEGRepresentation(image, 0.8)?.write(to: fileName)
            let _ = client.upload(from: fileName, completionHandler: { (response) in
                if let json = response?.json, let url = json["url"] as? String {
                    // Use Filestack handle
                    dprint(url)
                    completion(URL(string:url), nil)
                } else if let error = response?.error {
                    // Handle error
                    completion(nil,error)
                }
            })
        }
    }
//   class func uploadImage(_ image:UIImage, completion:@escaping (_ url:URL?, _ error:Error?) -> Void){
//        let storageRef = Storage.storage().reference()
//        guard let data = UIImageJPEGRepresentation(image, 0.8) else {
//            completion(nil, FileUploadError.cantGetData)
//            return
//        }
//        let fileName = UUID().uuidString + ".jpg"
//        let fileRef = storageRef.child("avatar").child(fileName)
//        _ = fileRef.putData(data, metadata:nil) { (metadata, error) in
//            if error != nil {
//                completion(nil, error)
//                return
//            }
//            guard let metadata = metadata else {
//                completion(nil, FileUploadError.fileDidnotUpdloaded)
//                return
//            }
//            completion(metadata.downloadURL(), nil)
//        }
//
//    }
  
}

