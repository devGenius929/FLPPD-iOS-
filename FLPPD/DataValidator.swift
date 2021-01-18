//
//  DataValidator.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/8/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation


class DataValidator {
  
  class func validName(_ name:String?) -> Bool {
    if let regex =
      try? NSRegularExpression(pattern: "^[a-z]{1,10}$", options: .caseInsensitive) {
      if let nameUnwrap = name{
        return nameUnwrap.lengthOfBytes(using: String.Encoding.utf8) > 2 &&
          regex.matches(in: nameUnwrap, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, nameUnwrap.lengthOfBytes(using: String.Encoding.utf8))).count > 0
      }
    }
    return false
  }
  
  class func validEmail(_ email:String?)  -> Bool{
    if let regex =
      try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive){
      
      if let emailUnwrap = email{
        return regex.matches(in: emailUnwrap, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, emailUnwrap.lengthOfBytes(using: String.Encoding.utf8))).count > 0
      }
    }
    return false
  }
  
  class func validTextFieldLenght(_ text: String?, lenght: Int) -> Bool{
    
    if let textCount = text?.count, textCount > lenght{
      
      return true
    }
    return false
  }
  
  class func validPhoneNumber(value: String?) -> Bool{
  
    let PHONE_REGEX = "^\\d{3} \\d{3} \\d{4}$"
    let phone = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    
    if let number = value{
      let result =  phone.evaluate(with: number)
      return result
    }
    
    return false
  }
}
