//
//  HouseSectionData.swift
//  MountCarmel
//
//  Created by Sandip on 27/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class HouseSectionData: WSResponseData {
    var _id : String?
    var house_no : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case house_no = "house_no"
    }
    
    required init(from decoder: Decoder) throws {
         try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        house_no = try values.decodeIfPresent(String.self, forKey: .house_no)
    }
}

