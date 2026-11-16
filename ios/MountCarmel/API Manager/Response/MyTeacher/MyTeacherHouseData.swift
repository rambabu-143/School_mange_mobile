//
//  MyTeacherHouseData.swift
//  MountCarmel
//
//  Created by Sandip on 08/11/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation

class MyTeacherHouseData: WSResponseData {
    
    var id : String?
    var house_incharge_id : [TeacherTypeData]?
    var house_no : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case house_incharge_id = "house_incharge_id"
        case house_no = "house_no"
        case id = "_id"
        
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id)
        house_incharge_id = try values.decodeIfPresent([TeacherTypeData].self, forKey: .house_incharge_id)
        house_no = try values.decodeIfPresent(String.self, forKey: .house_no)
        
    }
}
