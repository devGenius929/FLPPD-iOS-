//
//  Dictionary.swift
//  FLPPD
//
//  Created by Vlad Konon on 11/26/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation

extension Dictionary where Iterator.Element == (key: String, value: AnyObject) {
    func valueForKeyWithDefault(_ key:String, orDefault def:String = "") -> String {
        return (self[key] as? String) ?? def
    }
    func valueForKeyWithDefault(_ key:String, orDefault def:Int = 0) -> Int {
        return (self[key] as? Int) ?? def
    }
}
