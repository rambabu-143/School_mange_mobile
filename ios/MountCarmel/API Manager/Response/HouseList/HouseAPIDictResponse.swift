//
//  HouseAPIDictResponse.swift
//  MountCarmel
//
//  Created by Sandip on 25/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class HouseAPIDictResponse: WSResponseData {
    var data : HouseListData?
    var message : String?
    var status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(HouseListData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }
}

