//
//  LoginAPIClassTeacherID.swift
//  MountCarmel
//
//  Created by Sandip on 04/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class LoginAPIClassTeacherID: WSResponseData {
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
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(id, forKey: .id)
        try container.encode(standard, forKey: .standard)
        try container.encode(section, forKey: .section)
    }
}
