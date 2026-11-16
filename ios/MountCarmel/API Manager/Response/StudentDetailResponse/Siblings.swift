//
//  Siblings.swift
//  MountCarmel
//
//  Created by Sandip on 01/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class Siblings: WSResponseData {
    var admission_no : String?
    var sibling_id : LoginAPIStudentId?
   
    
    enum CodingKeys: String, CodingKey {
        
        case admission_no = "admission_no"
        case sibling_id = "sibling_id"
       
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        sibling_id = try values.decodeIfPresent(LoginAPIStudentId.self, forKey: .sibling_id)
    }
    
}

class Sibling_ID: WSResponseData {
    var id : String?
    var admission_no : String?
    var name : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case admission_no = "admission_no"
        case name = "name"
        
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        id = try values.decodeIfPresent(String.self, forKey: .id)
         name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
}

