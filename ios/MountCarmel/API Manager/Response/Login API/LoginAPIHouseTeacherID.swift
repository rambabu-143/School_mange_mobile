//
//  LoginAPIHouseTeacherID.swift
//  MountCarmel
//
//  Created by Sandip on 04/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class LoginAPIHouseTeacherID: WSResponseData {
    var _id : String?
    var house_no : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case house_no = "house_no"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        house_no = try values.decodeIfPresent(String.self, forKey: .house_no)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(house_no, forKey: .house_no)
    }
}
