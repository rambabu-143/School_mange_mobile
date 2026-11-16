//
//  WiseStudentData.swift
//  MountCarmel
//
//  Created by Sandip on 19/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
class Intellect : WSResponseData {
	var count : Int?
	var data : [AllCardTypeData]?

	enum CodingKeys: String, CodingKey {

		case count = "count"
		case data = "data"
	}

	required init(from decoder: Decoder) throws {
         try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		count = try values.decodeIfPresent(Int.self, forKey: .count)
		data = try values.decodeIfPresent([AllCardTypeData].self, forKey: .data)
	}

}
