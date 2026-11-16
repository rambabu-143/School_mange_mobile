//
//  SchoolCalanderAPIResponse.swift
//  MountCarmel
//
//  Created by Sandip on 12/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SchoolCalanderAPIResponse: WSResponseData {
    var status : Bool?
    var message : String?
    //var data : StudentDetailData?
    var holidays : [SubmitAttendanceData]?
    var events : [Events]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
        case holidays = "holidays"
        case events = "events"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        holidays = try values.decodeIfPresent([SubmitAttendanceData].self, forKey: .holidays)
        events = try values.decodeIfPresent([Events].self, forKey: .events)
        //data = try values.decodeIfPresent(StudentDetailData.self, forKey: .data)
    }
    
}
