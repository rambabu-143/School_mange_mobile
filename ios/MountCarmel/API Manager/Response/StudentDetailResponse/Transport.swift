//
//  FeesData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
class Transport : WSResponseData {
	var transport_type : String?
	var security : Security?

	enum CodingKeys: String, CodingKey {

		case transport_type = "transport_type"
		case security = "security"
	}

	required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

		let values = try decoder.container(keyedBy: CodingKeys.self)
		transport_type = try values.decodeIfPresent(String.self, forKey: .transport_type)
		//security = try values.decodeIfPresent(Security.self, forKey: .security)
	}

}

class Security : WSResponseData {
    var value : String?
    var year : String?
    
    enum CodingKeys: String, CodingKey {
        
        case value = "value"
        case year = "year"
    }
    
   required init(from decoder: Decoder) throws {
    try super.init(from: decoder)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        year = try values.decodeIfPresent(String.self, forKey: .year)
    }
    
}
