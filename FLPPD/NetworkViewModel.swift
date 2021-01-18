//
//  NetworkViewModel.swift
//  FLPPD
//
//  Created by PC on 10/1/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import RxSwift
struct ContactCellViewModel{
  let name:String
  let userId:Int
  let avatar:UIImage?
}

func searchContacts(searchTerm:String)->Observable<Contact?>?{
  let trimmedText =  searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
  if trimmedText.isEmpty {
    return nil
  }
  guard let observable = createSearchContactsObservable(trimmedText) else{
    return nil
  }
  return observable
  /*return observable.map({(contact:Contact?)->ContactCellViewModel? in
    guard let unwrappedContact = contact else {
      return nil
    }
    return processContact(unwrappedContact)
  })*/
}
func processContact(_ contact:Contact)->ContactCellViewModel{
  return ContactCellViewModel(name: contact.name,userId:contact.userId,avatar:contact.avatar)
}
