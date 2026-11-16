//
//  TimeTableData.swift
//  MountCarmel
//
//  Created by Sandip on 26/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class TimeTableData: WSResponseData {
    var status : Int?
    var resource : [TimeTableResourceData]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case resource = "resource"
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        resource = try values.decodeIfPresent([TimeTableResourceData].self, forKey: .resource)
        
    }
}

