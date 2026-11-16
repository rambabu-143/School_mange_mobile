//
//  FeesData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
class Address : WSResponseData {
	var local_address : String?
	var city : String?
	var state_id : LoginAPIStateId?
	var country_id : LoginAPICountryId?
	var pincode : String?

	enum CodingKeys: String, CodingKey {

		case local_address = "local_address"
		case city = "city"
		case state_id = "state_id"
		case country_id = "country_id"
		case pincode = "pincode"
	}

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		local_address = try values.decodeIfPresent(String.self, forKey: .local_address)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		state_id = try values.decodeIfPresent(LoginAPIStateId.self, forKey: .state_id)
		country_id = try values.decodeIfPresent(LoginAPICountryId.self, forKey: .country_id)
		pincode = try values.decodeIfPresent(String.self, forKey: .pincode)
	}

}
