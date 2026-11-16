//
//  HomeworkAPIResponse.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 18/08/24.
//  Copyright © 2024 Mount Carmel School. All rights reserved.
//

import Foundation

class StaffHomeworkDeleteAPIResponse : WSResponseData {
    var status : Bool?
    var message : String?
    var data : [StaffHomeworkData]?
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
        data = try values.decodeIfPresent([StaffHomeworkData].self, forKey: .data)
        path = try values.decodeIfPresent(String.self, forKey: .path)
    }
}
