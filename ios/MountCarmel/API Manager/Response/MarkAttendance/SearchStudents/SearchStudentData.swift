//
//  SearchStudentData.swift
//  MountCarmel
//
//  Created by Sandip on 08/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SearchStudentData: WSResponseData {
    var _id : String?
    var section_id : LoginAPIDepartmentId?
    var name : String?
    var profile_pic : String?
    var standard_id : LoginAPIDepartmentId?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case sectionid = "section_id"
        case name = "name"
        case profile_pic = "profile_pic"
        case standardid = "standard_id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        section_id = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .sectionid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        standard_id = try values.decodeIfPresent(LoginAPIDepartmentId.self, forKey: .standardid)
    }
}
