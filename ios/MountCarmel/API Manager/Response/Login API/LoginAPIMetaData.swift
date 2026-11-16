//
//	LoginAPIMetaData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIMetaData : WSResponseData {
    
    var schoolCode : String?
    var token : String?
    var yearSession : String?
    var school_type : String?
    
    
    enum CodingKeys: String, CodingKey {
        case schoolCode = "school_code"
        case token = "token"
        case yearSession = "year_session"
        case school_type = "school_type"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        schoolCode = try values.decodeIfPresent(String.self, forKey: .schoolCode)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        yearSession = try values.decodeIfPresent(String.self, forKey: .yearSession)
        school_type = try values.decodeIfPresent(String.self, forKey: .school_type)

    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schoolCode, forKey: .schoolCode)
        try container.encode(token, forKey: .token)
        try container.encode(yearSession, forKey: .yearSession)
        try container.encode(school_type, forKey: .school_type)
    }
}
