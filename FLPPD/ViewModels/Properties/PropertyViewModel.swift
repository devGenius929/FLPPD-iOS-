//
//  PropertiesViewModel.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 8/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit


public final class PropertyViewModel{
  
  //MARK:- Instance Properties
  public let property: FLPPDProperty
  
  public var propId: Int{
    return property.id
  }
  
  public let price: String
    public let rehub_cost:String
  public let street: String
  public let pubDate: String
  public let descriptionText: String
    public var starred:Bool = false 
  
  public var city: String{
    return "\(property.city ?? ""), \(property.state ?? "") \(property.zip_code ?? 00000)"
  }
  
  public var iconProType: UIImage{
    return property.property_type_id == 2 ? #imageLiteral(resourceName: "flipDealDot") : #imageLiteral(resourceName: "reantalDealDot")
  }
  
  public var arv: String{
    return property.property_type_id == 2 ? "ARV: \(property.arv_currency ?? "$0.0")" : "RR: \(property.arv_currency ?? "$0.0")"
  }
  
  public var proDetails: String{
     return "\(property.nbeds ?? "") beds • \(property.nbath ?? "") baths • \(property.sqft ?? 0) sqtf"
  }
  
  public var fullName: String{
    return "\(property.user.first_name ) \(property.user.last_name )"
  }
  
  
  
  public init(property: FLPPDProperty){
    self.property = property
    
    price = property.price_currency ?? "$0.0"
    street = property.street ?? "No address"
    pubDate = property.pubDate ?? "No date"
    descriptionText = property.description ?? "No information provided"
    starred = property.starred ?? false
    rehub_cost = property.rehub_cost != nil ? "\(property.rehub_cost!)" :  "$0.0"
  }

}
