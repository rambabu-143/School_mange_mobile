//
//  NoticeStaffData.swift
//  MountCarmel
//
//  Created by Sandip on 27/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class NoticeStaffData: WSResponseData {
    var id : String?
    var admission_no : String?
    var name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case admissionno = "admission_no"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admissionno)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
