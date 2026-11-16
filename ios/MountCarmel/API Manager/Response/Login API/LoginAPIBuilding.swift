//
//	LoginAPIBuilding.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIBuilding : WSResponseData {
    
    var buildingId : String?
    
    
    enum CodingKeys: String, CodingKey {
        case buildingId = "building_id"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        buildingId = try values.decodeIfPresent(String.self, forKey: .buildingId)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(buildingId, forKey: .buildingId)
    }
}
