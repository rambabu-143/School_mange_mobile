//
//  StandardSectionData.swift
//  MountCarmel
//
//  Created by Sandip on 27/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class StandardSectionData: WSResponseData {
    var _id : String?
    var standard : String?
    var section : String?
    var id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case standard = "standard"
        case section = "section"
        case id = "id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        standard = try values.decodeIfPresent(String.self, forKey: .standard)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
    
}

