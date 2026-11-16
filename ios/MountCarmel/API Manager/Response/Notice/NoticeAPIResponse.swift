//
//  NoticeAPIResponse.swift
//  MountCarmel
//
//  Created by Sandip on 27/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class NoticeAPIResponse: WSResponseData {
    var status : Bool?
    var message : String?
    var data : [NoticeData]?
    var path : String?
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
        case path = "path"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        data = try values.decodeIfPresent([NoticeData].self, forKey: .data)
    }
}

