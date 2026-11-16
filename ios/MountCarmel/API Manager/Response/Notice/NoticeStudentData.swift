//
//  NoticeStudentData.swift
//  MountCarmel
//
//  Created by Sandip on 27/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class NoticeStudentData: WSResponseData {
    var id : String?
    var first_name : String?
    var last_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case firstname = "first_name"
        case lastname = "last_name"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        first_name = try values.decodeIfPresent(String.self, forKey: .firstname)
        last_name = try values.decodeIfPresent(String.self, forKey: .lastname)
    }

}
