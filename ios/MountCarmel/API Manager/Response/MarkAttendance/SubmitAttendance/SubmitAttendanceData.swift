//
//  SubmitAttendanceData.swift
//  MountCarmel
//
//  Created by Sandip on 23/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SubmitAttendanceData: WSResponseData {
    var is_deleted : Bool?
    var _id : String?
    var date : String?
    var day : String?
    var standard_id : String?
    var status : String?
    var title : String?
    var remark : String?
    var location : String?
    var term : Int?
    var school_code : String?
    var branch_code : String?
    var year_session : String?
    var created_at : String?
    var updated_at : String?
    var updated_by : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case is_deleted = "is_deleted"
        case _id = "_id"
        case date = "date"
        case day = "day"
        case standard_id = "standard_id"
        case status = "status"
        case remark = "remark"
        case term = "term"
        case school_code = "school_code"
        case branch_code = "branch_code"
        case year_session = "year_session"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case updated_by = "updated_by"
       
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        day = try values.decodeIfPresent(String.self, forKey: .day)
        standard_id = try values.decodeIfPresent(String.self, forKey: .standard_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        remark = try values.decodeIfPresent(String.self, forKey: .remark)
        term = try values.decodeIfPresent(Int.self, forKey: .term)
        school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
       // branch_code = try values.decodeIfPresent(String.self, forKey: .branch_code)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        updated_by = try values.decodeIfPresent(String.self, forKey: .updated_by)
    }
    
}
