//
//  SummaryStudentData.swift
//  MountCarmel
//
//  Created by Sandip on 22/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SummaryStudentData: WSResponseData {
    var _id : String?
    var admission_no : String?
    var strclass : String?
    var section : String?
    var name : String?
    var sms_mobile : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case admission_no = "admission_no"
        case strclass = "class"
        case section = "section"
        case name = "name"
        case sms_mobile = "sms_mobile"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        strclass = try values.decodeIfPresent(String.self, forKey: .strclass)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        sms_mobile = try values.decodeIfPresent(String.self, forKey: .sms_mobile)
    }
    
}
