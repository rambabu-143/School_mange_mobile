//
//	WiseListData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class WiseListData : WSResponseData {
	var id : String?
	var admNo : Int?
	var admissionNo : String?
	var cardType : String?
	var createdAt : String?
	var emotion : Int?
	var intellect : Int?
	var isDeleted : Bool?
	var parentId : String?
	var reason : String?
	var remarks : String?
	var savedAt : String?
	var schoolCode : String?
	var staffBranch : String?
	var stature : Int?
	var status : Int?
	var studentId : WiseListStudentId?
	var timestamp : String?
	var updated : Int?
	var updatedAt : String?
	var wiseDate : String?
	var worthy : Int?

	enum CodingKeys: String, CodingKey {
		case id = "_id"
		case admNo = "adm_no"
		case admissionNo = "admission_no"
		case cardType = "card_type"
		case createdAt = "created_at"
		case emotion = "emotion"
		case intellect = "intellect"
		case isDeleted = "is_deleted"
		case parentId = "parent_id"
		case reason = "reason"
		case remarks = "remarks"
		case savedAt = "saved_at"
		case schoolCode = "school_code"
		case staffBranch = "staff_branch"
		case stature = "stature"
		case status = "status"
		case studentId = "student_id"
		case timestamp = "timestamp"
		case updated = "updated"
		case updatedAt = "updated_at"
		case wiseDate = "wise_date"
		case worthy = "worthy"
	}
    
	required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		admNo = try values.decodeIfPresent(Int.self, forKey: .admNo)
		admissionNo = try values.decodeIfPresent(String.self, forKey: .admissionNo)
		cardType = try values.decodeIfPresent(String.self, forKey: .cardType)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		emotion = try values.decodeIfPresent(Int.self, forKey: .emotion)
		intellect = try values.decodeIfPresent(Int.self, forKey: .intellect)
		isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
		parentId = try values.decodeIfPresent(String.self, forKey: .parentId)
		reason = try values.decodeIfPresent(String.self, forKey: .reason)
		remarks = try values.decodeIfPresent(String.self, forKey: .remarks)
		savedAt = try values.decodeIfPresent(String.self, forKey: .savedAt)
		schoolCode = try values.decodeIfPresent(String.self, forKey: .schoolCode)
		staffBranch = try values.decodeIfPresent(String.self, forKey: .staffBranch)
		stature = try values.decodeIfPresent(Int.self, forKey: .stature)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		studentId = try values.decodeIfPresent(WiseListStudentId.self, forKey: .studentId)
		timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
		updated = try values.decodeIfPresent(Int.self, forKey: .updated)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		wiseDate = try values.decodeIfPresent(String.self, forKey: .wiseDate)
		worthy = try values.decodeIfPresent(Int.self, forKey: .worthy)
	}
}
