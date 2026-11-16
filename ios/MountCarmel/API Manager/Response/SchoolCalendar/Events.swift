

import Foundation
class Events : WSResponseData {
	var is_deleted : Bool?
	var _id : String?
	var title : String?
	var event_for : String?
	var start_date : String?
	var end_date : String?
	var primary_color : String?
	var secondary_color : String?
	var location : String?
	var remark : String?
	var branch_code : Int?
	var created_at : String?
	var updated_at : String?
	var __v : Int?

	enum CodingKeys: String, CodingKey {

		case is_deleted = "is_deleted"
		case _id = "_id"
		case title = "title"
		case event_for = "event_for"
		case start_date = "start_date"
		case end_date = "end_date"
		case primary_color = "primary_color"
		case secondary_color = "secondary_color"
		case location = "location"
		case remark = "remark"
		case branch_code = "branch_code"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case __v = "__v"
	}

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		event_for = try values.decodeIfPresent(String.self, forKey: .event_for)
		start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
		end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
		primary_color = try values.decodeIfPresent(String.self, forKey: .primary_color)
		secondary_color = try values.decodeIfPresent(String.self, forKey: .secondary_color)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		remark = try values.decodeIfPresent(String.self, forKey: .remark)
		branch_code = try values.decodeIfPresent(Int.self, forKey: .branch_code)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
	}

}
