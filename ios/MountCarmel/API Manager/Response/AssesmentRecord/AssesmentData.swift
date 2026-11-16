//
//  AssesmentData.swift
//  MountCarmel
//
//  Created by Sandip on 01/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class AssesmentData: WSResponseData {
    var _id : String?
    var assessment_record : String?
   
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case assessment_record = "assessment_record"
        
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        assessment_record = try values.decodeIfPresent(String.self, forKey: .assessment_record)
        
    }
}
