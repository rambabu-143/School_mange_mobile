//
//  ComboSubjects.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ComboSubjects: WSResponseData {
    var subject_charge : Int?
    var charges_by : String?
    var _id : String?
    var subject_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case subject_charge = "subject_charge"
        case charges_by = "charges_by"
        case _id = "_id"
        case subject_name = "subject_name"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subject_charge = try values.decodeIfPresent(Int.self, forKey: .subject_charge)
        charges_by = try values.decodeIfPresent(String.self, forKey: .charges_by)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        subject_name = try values.decodeIfPresent(String.self, forKey: .subject_name)
    }
    
}
