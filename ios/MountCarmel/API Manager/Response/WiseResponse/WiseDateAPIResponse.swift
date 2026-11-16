//
//  WiseDateAPIResponse.swift
//  MountCarmel
//
//  Created by Sandip on 13/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class WiseDateAPIResponse: WSResponseData {
    var status : Bool?
    var message : String?
    var data : WiseDateData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(WiseDateData.self, forKey: .data)
    }

}
