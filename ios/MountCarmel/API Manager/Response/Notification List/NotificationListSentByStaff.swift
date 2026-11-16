//
//	NotificationListSentByStaff.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class NotificationListSentByStaff : WSResponseData {
	var id : String?
	var firstName : String?
	var lastName : String?

	enum CodingKeys: String, CodingKey {
		case id = "_id"
		case firstName = "first_name"
		case lastName = "last_name"
	}
    
	required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
	}
}
