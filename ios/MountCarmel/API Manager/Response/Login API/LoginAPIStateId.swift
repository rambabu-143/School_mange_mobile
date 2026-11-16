//
//	LoginAPIStateId.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIStateId : WSResponseData {
    
    var ID : String?
    var stateName : String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case stateName = "state_name"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(String.self, forKey: .id)
        stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .id)
        try container.encode(stateName, forKey: .stateName)
    }
}
