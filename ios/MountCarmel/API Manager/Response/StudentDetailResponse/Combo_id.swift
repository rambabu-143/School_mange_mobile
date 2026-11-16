//
//  ComboData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
class Combo_id : WSResponseData {
	var subjects : [ComboSubjects]?
	var sections : [String]?
	var standard_sections : [String]?
	var _id : String?
	var name : String?
	var standard_id : String?
	var year_session : String?
	var branch_code : Int?
	var order : Int?
	var created_at : String?
	var updated_at : String?
	var __v : Int?

	enum CodingKeys: String, CodingKey {

		case subjects = "subjects"
		case sections = "sections"
		case standard_sections = "standard_sections"
		case _id = "_id"
		case name = "name"
		case standard_id = "standard_id"
		case year_session = "year_session"
		case branch_code = "branch_code"
		case order = "order"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case __v = "__v"
	}

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		subjects = try values.decodeIfPresent([ComboSubjects].self, forKey: .subjects)
		sections = try values.decodeIfPresent([String].self, forKey: .sections)
		standard_sections = try values.decodeIfPresent([String].self, forKey: .standard_sections)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		standard_id = try values.decodeIfPresent(String.self, forKey: .standard_id)
		year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
		branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
		order = try values.decodeIfPresent(Int.self, forKey: .order)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
	}

}
