//
//  AllCardTypeData.swift
//  MountCarmel
//
//  Created by Sandip on 19/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import Foundation

class Absent : WSResponseData {
	var type : String?
	var value : Int?
	var _id : String?
	var student_id : String?
	var reason : String?
	var details : String?
	var information : String?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case value = "value"
		case _id = "_id"
		case student_id = "student_id"
		case reason = "reason"
		case details = "details"
		case information = "information"
	}

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		//value = try values.decodeIfPresent(Int.self, forKey: .value)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		student_id = try values.decodeIfPresent(String.self, forKey: .student_id)
		reason = try values.decodeIfPresent(String.self, forKey: .reason)
		details = try values.decodeIfPresent(String.self, forKey: .details)
		information = try values.decodeIfPresent(String.self, forKey: .information)
	}

}
