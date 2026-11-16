//
//	AssignmentData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AssignmentData : WSResponseData {
//	var v : Int?
//	var id : String?
//	var attachment : String?
//	var content : String?
//	var endDate : String?
//	var platform : String?
//	var readFlag : Bool?
//	var sentByStaff : String?
//	var startDate : String?
//	var studentId : String?
//	var title : String?
//	var type : String?
//    var imageURL : String?
//
//
//	enum CodingKeys: String, CodingKey {
//		case v = "__v"
//		case id = "_id"
//		case attachment = "attachment"
//		case content = "content"
//		case endDate = "end_date"
//		case platform = "platform"
//		case readFlag = "read_flag"
//		case sentByStaff = "sent_by_staff"
//		case startDate = "start_date"
//		case studentId = "student_id"
//		case title = "title"
//		case type = "type"
//        case imageURL = "image_url"
//	}
//
//	required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		v = try values.decodeIfPresent(Int.self, forKey: .v)
//		id = try values.decodeIfPresent(String.self, forKey: .id)
//		attachment = try values.decodeIfPresent(String.self, forKey: .attachment)
//		content = try values.decodeIfPresent(String.self, forKey: .content)
//		endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
//		platform = try values.decodeIfPresent(String.self, forKey: .platform)
//		readFlag = try values.decodeIfPresent(Bool.self, forKey: .readFlag)
//		sentByStaff = try values.decodeIfPresent(String.self, forKey: .sentByStaff)
//		startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
//		studentId = try values.decodeIfPresent(String.self, forKey: .studentId)
//		title = try values.decodeIfPresent(String.self, forKey: .title)
//		type = try values.decodeIfPresent(String.self, forKey: .type)
//        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
//	}
//
    var attachments : [String]?
    var _id : String?
    var title : String?
    var text : String?
    var type : String?
    var start_date : String?
    var end_date : String?
    var sent_by_staff : Sent_by_staff?
    var created_at : String?

    enum CodingKeys: String, CodingKey {

        case attachments = "attachments"
        case _id = "_id"
        case title = "title"
        case text = "text"
        case type = "type"
        case start_date = "start_date"
        case end_date = "end_date"
        case sent_by_staff = "sent_by_staff"
        case created_at = "created_at"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attachments = try values.decodeIfPresent([String].self, forKey: .attachments)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        sent_by_staff = try values.decodeIfPresent(Sent_by_staff.self, forKey: .sent_by_staff)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    }
}

class Sent_by_staff : WSResponseData {
    var _id : String?
    var name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
}
