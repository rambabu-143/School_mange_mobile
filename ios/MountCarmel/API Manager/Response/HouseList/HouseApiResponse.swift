//
//  HouseApiResponse.swift
//  MountCarmel
//
//  Created by Sandip on 24/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class HouseApiResponse: WSResponseData {
    var data : [HouseListData]?
    var message : String?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([HouseListData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}
