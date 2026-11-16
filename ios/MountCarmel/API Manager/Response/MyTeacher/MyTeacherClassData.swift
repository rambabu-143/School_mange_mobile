//
//  MyTeacherClassData.swift
//  MountCarmel
//
//  Created by Sandip on 08/11/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation

class MyTeacherClassData: WSResponseData {
    
    var id : String?
    var class_teacher_id : TeacherTypeData?
    var helper_teacher_id : TeacherTypeData?
    
    
    enum CodingKeys: String, CodingKey {
        
        case class_teacher_id = "class_teacher_id"
        case helper_teacher_id = "helper_teacher_id"
        case id = "id"
        
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id)
        class_teacher_id = try values.decodeIfPresent(TeacherTypeData.self, forKey: .class_teacher_id)
        helper_teacher_id = try values.decodeIfPresent(TeacherTypeData.self, forKey: .helper_teacher_id)
        
    }
}

class TeacherTypeData: WSResponseData {
   
    var _id : String?
    var name : String?
    var profile_pic : String?
    var type: String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case name = "name"
        case profile_pic = "profile_pic"
        
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
    }
    
}
