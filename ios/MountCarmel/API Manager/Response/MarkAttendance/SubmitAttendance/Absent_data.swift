//
//  AllCardTypeData.swift
//  MountCarmel
//
//  Created by Sandip on 19/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import Foundation

class Absent_data : WSResponseData {
	var is_sms_sent : Bool?
	var is_deleted : Bool?
	var _id : String?
	var standard_section_id : String?
	var __v : Int?
	
	var branch_code : Int?
	var created_at : String?
	var date : String?
	var platform : String?
	var school_code : String?
	var staff_id : String?
	var updated_at : String?
	var year_session : String?
    
    var absent : [Absent]?

	enum CodingKeys: String, CodingKey {

        case is_sms_sent = "is_sms_sent"
		case is_deleted = "is_deleted"
		case _id = "_id"
		case standard_section_id = "standard_section_id"
		case __v = "__v"
		
		case branch_code = "branch_code"
		case created_at = "created_at"
		case date = "date"
		case platform = "platform"
		case school_code = "school_code"
		case staff_id = "staff_id"
		case updated_at = "updated_at"
		case year_session = "year_session"
        
        case absent = "absent"
	}

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		is_sms_sent = try values.decodeIfPresent(Bool.self, forKey: .is_sms_sent)
		is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		standard_section_id = try values.decodeIfPresent(String.self, forKey: .standard_section_id)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
		branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		platform = try values.decodeIfPresent(String.self, forKey: .platform)
		school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
		staff_id = try values.decodeIfPresent(String.self, forKey: .staff_id)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
        absent = try values.decodeIfPresent([Absent].self, forKey: .absent)

	}

}
