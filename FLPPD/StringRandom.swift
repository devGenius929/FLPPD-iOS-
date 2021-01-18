//
//  StringRandom.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/28/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation

public extension String {
    static func random(length:Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = charSet.map { String($0) }
        var s:String = ""
        for _ in (1...length) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
}
