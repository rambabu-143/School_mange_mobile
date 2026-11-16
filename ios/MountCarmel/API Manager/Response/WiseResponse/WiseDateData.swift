//
//  WiseDateData.swift
//  MountCarmel
//
//  Created by Sandip on 13/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class WiseDateData: WSResponseData {
    var is_deleted : Bool?
    var _id : String?
    var created_at : String?
    var updated_at : String?
    var year_session : String?
    var start_date : String?
    var end_date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case is_deleted = "is_deleted"
        case _id = "_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case year_session = "year_session"
        case start_date = "start_date"
        case end_date = "end_date"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
    }
}
