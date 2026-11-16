//
//	LoginAPITransportId.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPITransportId : WSResponseData {
    
    var ID : String?
    var routesDetails : [LoginAPIRoutesDetail]?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case routesDetails = "routes_details"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(String.self, forKey: .id)
        routesDetails = try values.decodeIfPresent([LoginAPIRoutesDetail].self, forKey: .routesDetails)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .id)
        try container.encode(routesDetails, forKey: .routesDetails)
    }
}
