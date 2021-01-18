//
//  GlossaryModel.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/15/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation


struct GlossaryListItem: Codable {
    let title:String
    let fileName:String
}

struct GlossaryListSection: Codable {
    let sectionTitle:String
    let items:[GlossaryListItem]
}

struct GlossaryList:Codable {
    let sections:[GlossaryListSection]
}

