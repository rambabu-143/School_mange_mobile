//
//	LoginAPIToken.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIToken : WSResponseData {
    
    var ID : String?
    var platform : String?
    var token : String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case platform = "platform"
        case token = "token"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(String.self, forKey: .id)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .id)
        try container.encode(platform, forKey: .platform)
        try container.encode(token, forKey: .token)
    }
}
