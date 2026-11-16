//
//  SubmitAttendanceAPIResponse.swift
//  MountCarmel
//
//  Created by Sandip on 09/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SubmitAttendanceAPIResponse: WSResponseData {
    var status : Bool?
    var message : String?
    var total : Int?
    var present : Float?
    var absent : Float?
    var fullAbsent : Int?
    var halfAbsent : Float?
    var absent_data : [Absent_data]?
    var data : [SubmitAttendanceData]?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case total = "total"
        case present = "present"
        case absent = "absent"
        case fullAbsent = "full_Absent"
        case halfAbsent = "half_Absent"
        case data = "data"
        case absentdata = "absent_data"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        present = try values.decodeIfPresent(Float.self, forKey: .present)
        absent = try values.decodeIfPresent(Float.self, forKey: .absent)
        fullAbsent = try values.decodeIfPresent(Int.self, forKey: .fullAbsent)
        halfAbsent = try values.decodeIfPresent(Float.self, forKey: .halfAbsent)
         data = try values.decodeIfPresent([SubmitAttendanceData].self, forKey: .data)
        absent_data = try values.decodeIfPresent([Absent_data].self, forKey: .absentdata)
    }

}
