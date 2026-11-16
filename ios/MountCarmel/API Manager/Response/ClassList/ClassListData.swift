//
//  ClassListData.swift
//  MountCarmel
//
//  Created by Sandip on 25/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ClassListData: WSResponseData {
    var v : Int?
    var id : String?
    var createdat : String?
    var name : String?
    var orderno : Int?
    var schooltype : String?
    // var isdeleted : UInt?
    var updatedat : String?
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case createdat = "created_at"
        case name = "name"
        case orderno = "order_no"
        case schooltype = "school_type"
        // case isdeleted = "is_deleted"
        case updatedat = "updated_at"
        
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        createdat = try values.decodeIfPresent(String.self, forKey: .createdat)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        orderno = try values.decodeIfPresent(Int.self, forKey: .orderno)
        schooltype = try values.decodeIfPresent(String.self, forKey: .schooltype)
        // isdeleted = try values.decodeIfPresent(UInt.self, forKey: .isdeleted)
        updatedat = try values.decodeIfPresent(String.self, forKey: .updatedat)
        
    }
}

