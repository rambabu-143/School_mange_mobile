//
//  MyTeacherResponse.swift
//  MountCarmel
//
//  Created by Sandip on 08/11/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation

class MyTeacherResponse: WSResponseData {
    var status : Bool?
    var message : String?
    var classData : MyTeacherClassData?
    var subjects : [Subjects]?
    var house : MyTeacherHouseData?
    var path : String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case classData = "class"
        case subjects = "subjects"
        case house = "house"
        case path = "path"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        classData = try values.decodeIfPresent(MyTeacherClassData.self, forKey: .classData)
        subjects = try values.decodeIfPresent([Subjects].self, forKey: .subjects)
        house = try values.decodeIfPresent(MyTeacherHouseData.self, forKey: .house)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        
    }
}
