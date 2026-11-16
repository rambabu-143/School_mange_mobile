//
//	LoginAPIQualificationId.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIQualificationId : WSResponseData {
    
    var ID : String?
    var qualification : String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case qualification = "qualification"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(String.self, forKey: .id)
        qualification = try values.decodeIfPresent(String.self, forKey: .qualification)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .id)
        try container.encode(qualification, forKey: .qualification)
    }
}
