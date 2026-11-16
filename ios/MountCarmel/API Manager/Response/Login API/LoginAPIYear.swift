//
//	LoginAPIYear.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIYear : WSResponseData {
    
    var isDefault : Bool?
    var yearSession : String?
    
    
    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case yearSession = "year_session"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
        yearSession = try values.decodeIfPresent(String.self, forKey: .yearSession)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isDefault, forKey: .isDefault)
        try container.encode(yearSession, forKey: .yearSession)
    }
}
