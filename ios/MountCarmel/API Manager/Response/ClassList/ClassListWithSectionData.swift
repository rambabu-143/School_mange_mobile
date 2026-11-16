//
//  ClassListWithSectionData.swift
//  MountCarmel
//
//  Created by Sandip on 13/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ClassListWithSectionData: WSResponseData {
    var _id : String?
    var standard : String?
    var section : String?
    var created_at : String?
    var id : String?
    var section_id : LoginAPIDepartmentId?
    var standard_id : LoginAPIDepartmentId?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case standard = "standard"
        case section = "section"
        case created_at = "created_at"
        case id = "id"
        case section_id = "section_id"
        case standard_id = "standard_id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        standard = try values.decodeIfPresent(String.self, forKey: .standard)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        section_id = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .section_id)
        
        standard_id = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .standard_id)
        
    }
}
