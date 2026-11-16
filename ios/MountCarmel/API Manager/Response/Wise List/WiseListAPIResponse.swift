//
//	WiseListAPIResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class WiseListAPIResponse : WSResponseData {
	var data : [WiseListData]?
	var message : String?
	var status : Bool?

	enum CodingKeys: String, CodingKey {
		case data = "data"
		case message = "message"
		case status = "status"
	}
    
	required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		data = try values.decodeIfPresent([WiseListData].self, forKey: .data)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
	}
}
