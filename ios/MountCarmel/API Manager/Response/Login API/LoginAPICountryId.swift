//
//	LoginAPICountryId.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPICountryId : WSResponseData {
    
    var ID : String?
    var countryName : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case countryName = "country_name"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(String.self, forKey: .id)
        countryName = try values.decodeIfPresent(String.self, forKey: .countryName)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .id)
        try container.encode(countryName, forKey: .countryName)
    }
}
