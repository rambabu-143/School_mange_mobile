//
//  ComboData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ComboData: WSResponseData {
    var combo_id : String?
    var combo_name : String?
    var status : String?
    var date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case combo_id = "combo_id"
        case combo_name = "combo_name"
        case status = "status"
        case date = "date"
    }
    
   required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        combo_id = try values.decodeIfPresent(String.self, forKey: .combo_id)
        combo_name = try values.decodeIfPresent(String.self, forKey: .combo_name)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        date = try values.decodeIfPresent(String.self, forKey: .date)
    }
    
}
