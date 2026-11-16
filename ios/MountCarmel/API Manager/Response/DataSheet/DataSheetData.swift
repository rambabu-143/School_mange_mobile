//
//  DataSheetData.swift
//  MountCarmel
//
//  Created by Sandip on 01/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class DataSheetData: WSResponseData {
    var is_deleted : Bool?
    var _id : String?
    var year_session : String?
    var school_code : String?
    var attachment : String?
    var platform : String?
    var created_at : String?
    var __v : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case is_deleted = "is_deleted"
        case _id = "_id"
        case year_session = "year_session"
        case school_code = "school_code"
        case attachment = "attachment"
        case platform = "platform"
        case created_at = "created_at"
        case __v = "__v"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
        school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
        attachment = try values.decodeIfPresent(String.self, forKey: .attachment)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
    }
    
}

