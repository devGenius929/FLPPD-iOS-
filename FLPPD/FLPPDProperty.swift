//
//  Property.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/2/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//
import Foundation
import MapKit
import RxSwift


public struct FLPPDPhoto:Codable {
    var id:Int
    var image:String
}

public struct FLPPDProperty:Decodable{
  
  //MARK: propeties
  var id: Int
  var arv: Int?
  var rehub_cost:Int?
  var price: Int?
  var street: String?
  var city: String?
  var state: String?
  var zip_code: Int?
  var nbeds: String?
  var nbath: String?
  var description: String?
  var sqft: Int?
  var parking:String?
  var zoning:String?
  var property_type_id:Int
  var property_listing_id:Int
  var default_img: String?
  var first_name: String?
  var last_name: String?
  var email: String?
  var created_at_in_words: String?
  var pubDate: String?
  var price_currency: String?
  var arv_currency: String?
  var user:User
    var starred:Bool? = false
    var photos:[FLPPDPhoto]
    // extra
    var property_category:String?
    var number_unit:Int?
    var year_built:Int32?
    var lot_size:String?
}


public struct FLPPDPropertyViewModel{
  let flppdProperty:FLPPDProperty
  var avatarURL:URL
  var defaultImageURL:URL
}
func getPropertiesObservable(_ user_id:Int? = nil, _ filters:String? = nil)->Observable<FLPPDPropertyViewModel>?{
  let header = [
    "Authorization": ClientAPI.default.authToken,
    "Accept": "application/json"
  ]
  var urlString = ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + ClientAPI.Constants.FLPPDMethods.properties
    var limit = !InAppPurchasesController.default.proSubsciptionIsActive
    if let user_id = user_id {
        urlString += "?user_id=\(user_id)"
        if user_id == ClientAPI.currentUser!.user_id {
            limit = false
        }
        if limit {
            urlString += "&limit=5"
        }
    }
    else if limit {
        urlString += "?limit=5"
    }
    if let filters = filters {
        if urlString.contains("?") {
            urlString += "&" + filters
        }
        else {
            urlString += "?" + filters
        }
    }
  let url = URL(string:urlString)!
  guard let urlRequest = try? URLRequest(url: url, method: .get,headers:header) else{
    return nil
  }
  
  return URLSession.shared.rx.data(request:urlRequest).flatMap({(json:Data)->Observable<(FLPPDProperty,URL,URL)> in
    let decoder = JSONDecoder()
    var results = [FLPPDProperty]()
    do {
        results = try decoder.decode(Array<FLPPDProperty>.self, from: json)
            
    } catch let error {
        dprint("decoder error:" + error.localizedDescription)
        return Observable.empty()
    }
    var returnObservable:[Observable<(FLPPDProperty,URL,URL)>] = []
    
    for property in results {
        let avatarStr = property.user.avatar
        let avatarURL = URL(string:avatarStr)!
        let avatarObservable = Observable.just(avatarURL)
        var defaultImgObservable:Observable<URL>? = nil
        if  let defaultImgURL =  URL(string:property.default_img!), defaultImgURL.host != nil{
            defaultImgObservable = Observable.just(defaultImgURL)
        }
        else {
            defaultImgObservable = Observable.just(ClientAPI.defautPropertImageUrl)
        }
      returnObservable.append(Observable.combineLatest(Observable.of(property),avatarObservable, defaultImgObservable!))
    }
    return Observable.concat(returnObservable)
  }).map({(response)->FLPPDPropertyViewModel in
    return FLPPDPropertyViewModel(flppdProperty: response.0, avatarURL: response.1, defaultImageURL: response.2)
  })
}

func getFavoritePropertiesObservable()->Observable<FLPPDPropertyViewModel>?{
    let header = [
        "Authorization": ClientAPI.default.authToken,
        "Accept": "application/json"
    ]
    let urlString = ClientAPI.Constants.apiBaseUrl + ClientAPI.Constants.apiPath + "favorites"
    let url = URL(string:urlString)!
    guard let urlRequest = try? URLRequest(url: url, method: .get,headers:header) else{
        return nil
    }
    
    return URLSession.shared.rx.data(request:urlRequest).flatMap({(json:Data)->Observable<(FLPPDProperty,URL, URL)> in
        let decoder = JSONDecoder()
        var results = [FLPPDProperty]()
        do {
            results = try decoder.decode(Array<FLPPDProperty>.self, from: json)
            
        } catch let error {
            dprint("decoder error:" + error.localizedDescription)
            return Observable.empty()
        }
        var returnObservable:[Observable<(FLPPDProperty,URL,URL)>] = []
        
        for property in results {
            let avatarStr = property.user.avatar
            let avatarURL = URL(string:avatarStr)!
            let avatarObservable = Observable.just(avatarURL)
            var defaultImgObservable:Observable<URL>? = nil
            if  let defaultImgURL =  URL(string:property.default_img!), defaultImgURL.host != nil{
                defaultImgObservable = Observable.just(defaultImgURL)
            }
            else {
                defaultImgObservable = Observable.just(ClientAPI.defautPropertImageUrl)
            }
            returnObservable.append(Observable.combineLatest(Observable.of(property),avatarObservable,defaultImgObservable!))
        }
        return Observable.concat(returnObservable)
    }).map({(response)->FLPPDPropertyViewModel in
        return FLPPDPropertyViewModel(flppdProperty: response.0, avatarURL: response.1, defaultImageURL: response.2)
    })
}
