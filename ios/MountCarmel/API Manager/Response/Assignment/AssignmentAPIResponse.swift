//
//	AssignmentAPIResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AssignmentAPIResponse : WSResponseData {
	var data : [AssignmentData]?
	var message : String?
	var path : String?
	var status : Bool?
    
	enum CodingKeys: String, CodingKey {
		case data = "data"
		case message = "message"
		case path = "path"
		case status = "status"
	}
    
	required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		data = try values.decodeIfPresent([AssignmentData].self, forKey: .data)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		path = try values.decodeIfPresent(String.self, forKey: .path)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
	}
}
