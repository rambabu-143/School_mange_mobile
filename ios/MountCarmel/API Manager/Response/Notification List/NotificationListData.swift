//
//	NotificationListData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class NotificationListData : WSResponseData {

	var v : Int?
	var id : String?
	var createdAt : String?
	var isDeleted : Bool?
	var mobileNo : String?
	var notificationType : String?
	var platform : String?
	var readFlag : Bool?
	var receiverType : String?
	var responseStatus : Bool?
	var schoolCode : String?
	var sentByStaff : NotificationListSentByStaff?
	var studentId : NotificationListStudentId?
	var text : String?
	var yearSession : String?


	enum CodingKeys: String, CodingKey {
		case v = "__v"
		case id = "_id"
		case createdAt = "created_at"
		case isDeleted = "is_deleted"
		case mobileNo = "mobile_no"
		case notificationType = "notification_type"
		case platform = "platform"
		case readFlag = "read_flag"
		case receiverType = "receiver_type"
		case responseStatus = "response_status"
		case schoolCode = "school_code"
		case sentByStaff
		case studentId
		case text = "text"
		case yearSession = "year_session"
	}
    
	required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		v = try values.decodeIfPresent(Int.self, forKey: .v)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
		mobileNo = try values.decodeIfPresent(String.self, forKey: .mobileNo)
		notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
		platform = try values.decodeIfPresent(String.self, forKey: .platform)
		readFlag = try values.decodeIfPresent(Bool.self, forKey: .readFlag)
		receiverType = try values.decodeIfPresent(String.self, forKey: .receiverType)
		responseStatus = try values.decodeIfPresent(Bool.self, forKey: .responseStatus)
		schoolCode = try values.decodeIfPresent(String.self, forKey: .schoolCode)
		sentByStaff = try NotificationListSentByStaff(from: decoder)
		studentId = try NotificationListStudentId(from: decoder)
		text = try values.decodeIfPresent(String.self, forKey: .text)
		yearSession = try values.decodeIfPresent(String.self, forKey: .yearSession)
	}


}
