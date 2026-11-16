//
//  RealTimeAPIResponse.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 06/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation

class RealTimeAPIResponse : WSResponseData {
    var status: Bool?
    var message: String?
    var data: String? // "dd-mm-yyyy hh:mm:ss pm/am"
    var current_time: String? // datetime string
    var today_date: String? // "yyyy-mm-dd"
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
        case current_time = "current_time"
        case today_date = "today_date"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        current_time = try values.decodeIfPresent(String.self, forKey: .current_time)
        today_date = try values.decodeIfPresent(String.self, forKey: .today_date)
    }
}
