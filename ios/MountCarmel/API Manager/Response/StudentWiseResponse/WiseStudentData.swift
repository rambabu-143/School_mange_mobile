//
//  WiseStudentData.swift
//  MountCarmel
//
//  Created by Sandip on 19/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation

class WiseStudentData: WSResponseData {
    var _id : String?
    var admission_no : String?
    var name : String?
    var standard_section_id : Standard_section_id?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case admission_no = "admission_no"
        case name = "name"
        case standard_section_id = "standard_section_id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        standard_section_id = try values.decodeIfPresent(Standard_section_id.self, forKey: .standard_section_id)
    }
}

class Standard_section_id : WSResponseData {
    var sectionid : String?
    var section : String?
    var standard : String?
    var id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case sectionid = "_id"
        case section = "section"
        case standard = "standard"
        case id = "id"
    }
    
    required init(from decoder: Decoder) throws {
         try super.init(from: decoder)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sectionid = try values.decodeIfPresent(String.self, forKey: .sectionid)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        standard = try values.decodeIfPresent(String.self, forKey: .standard)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
    
}
