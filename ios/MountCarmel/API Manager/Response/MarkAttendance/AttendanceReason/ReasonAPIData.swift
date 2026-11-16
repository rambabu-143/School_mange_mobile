//
//  ReasonAPIData.swift
//  MountCarmel
//
//  Created by Sandip on 10/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ReasonAPIData: WSResponseData {
    var is_deleted : Bool?
    var _id : String?
    var reason : String?
    var created_at : String?
    var updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case is_deleted = "is_deleted"
        case _id = "_id"
        case reason = "reason"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
}
