//
//  WiseClassAPIResponse.swift
//  MountCarmel
//
//  Created by Sandip on 11/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class WiseClassAPIResponse: WSResponseData {
    var status : Bool?
    var message : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
       
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
       
    }
}
