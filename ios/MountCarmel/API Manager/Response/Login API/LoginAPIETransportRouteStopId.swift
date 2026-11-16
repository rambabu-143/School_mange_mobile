//
//	LoginAPIETransportRouteStopId.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIETransportRouteStopId : WSResponseData {
    
    var stopName : String?
    
    
    enum CodingKeys: String, CodingKey {
        case stopName = "stop_name"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stopName = try values.decodeIfPresent(String.self, forKey: .stopName)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stopName, forKey: .stopName)
    }
}
