//
//	NotificationListStudentId.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class NotificationListStudentId : WSResponseData {
	var id : String?
	var admissionNo : String?
	var name : String?

	enum CodingKeys: String, CodingKey {
		case id = "_id"
		case admissionNo = "admission_no"
		case name = "name"
	}
    
	required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		admissionNo = try values.decodeIfPresent(String.self, forKey: .admissionNo)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}
}
