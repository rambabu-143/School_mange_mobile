//
//	LoginAPIAddres.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIAddres : WSResponseData {
	var city : String?
	var countryId : LoginAPICountryId?
	var localAddress : String?
	var pincode : String?
	var stateId : LoginAPIStateId?

	enum CodingKeys: String, CodingKey {
		case city = "city"
		case countryId
		case localAddress = "local_address"
		case pincode = "pincode"
		case stateId = "state_id"
	}
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decodeIfPresent(String.self, forKey: .city)
       // countryId = try values.decodeIfPresent(LoginAPICountryId.self, forKey: .countryId)
        localAddress = try values.decodeIfPresent(String.self, forKey: .localAddress)
        pincode = try values.decodeIfPresent(String.self, forKey: .pincode)
        //stateId = try values.decodeIfPresent(LoginAPIStateId.self, forKey: .stateId)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(city, forKey: .city)
        try container.encode(countryId, forKey: .countryId)
        try container.encode(localAddress, forKey: .localAddress)
        try container.encode(pincode, forKey: .pincode)
        try container.encode(stateId, forKey: .stateId)
    }
}
