//
//  FeesData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
class ReceivingObject : WSResponseData {
	var apr : Int?
	var may : Int?
	var jun : Int?
	var jul : Int?
	var aug : Int?
	var sep : Int?
	var oct : Int?
	var nov : Int?
	var dec : Int?
	var jan : Int?
	var feb : Int?
	var mar : Int?
	var apr_fine : Int?
	var may_fine : Int?
	var jun_fine : Int?
	var jul_fine : Int?
	var aug_fine : Int?
	var sep_fine : Int?
	var oct_fine : Int?
	var nov_fine : Int?
	var dec_fine : Int?
	var jan_fine : Int?
	var feb_fine : Int?
	var mar_fine : Int?

	enum CodingKeys: String, CodingKey {

		case apr = "apr"
		case may = "may"
		case jun = "jun"
		case jul = "jul"
		case aug = "aug"
		case sep = "sep"
		case oct = "oct"
		case nov = "nov"
		case dec = "dec"
		case jan = "jan"
		case feb = "feb"
		case mar = "mar"
		case apr_fine = "apr_fine"
		case may_fine = "may_fine"
		case jun_fine = "jun_fine"
		case jul_fine = "jul_fine"
		case aug_fine = "aug_fine"
		case sep_fine = "sep_fine"
		case oct_fine = "oct_fine"
		case nov_fine = "nov_fine"
		case dec_fine = "dec_fine"
		case jan_fine = "jan_fine"
		case feb_fine = "feb_fine"
		case mar_fine = "mar_fine"
	}

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		apr = try values.decodeIfPresent(Int.self, forKey: .apr)
		may = try values.decodeIfPresent(Int.self, forKey: .may)
		jun = try values.decodeIfPresent(Int.self, forKey: .jun)
		jul = try values.decodeIfPresent(Int.self, forKey: .jul)
		aug = try values.decodeIfPresent(Int.self, forKey: .aug)
		sep = try values.decodeIfPresent(Int.self, forKey: .sep)
		oct = try values.decodeIfPresent(Int.self, forKey: .oct)
		nov = try values.decodeIfPresent(Int.self, forKey: .nov)
		dec = try values.decodeIfPresent(Int.self, forKey: .dec)
		jan = try values.decodeIfPresent(Int.self, forKey: .jan)
		feb = try values.decodeIfPresent(Int.self, forKey: .feb)
		mar = try values.decodeIfPresent(Int.self, forKey: .mar)
		apr_fine = try values.decodeIfPresent(Int.self, forKey: .apr_fine)
		may_fine = try values.decodeIfPresent(Int.self, forKey: .may_fine)
		jun_fine = try values.decodeIfPresent(Int.self, forKey: .jun_fine)
		jul_fine = try values.decodeIfPresent(Int.self, forKey: .jul_fine)
		aug_fine = try values.decodeIfPresent(Int.self, forKey: .aug_fine)
		sep_fine = try values.decodeIfPresent(Int.self, forKey: .sep_fine)
		oct_fine = try values.decodeIfPresent(Int.self, forKey: .oct_fine)
		nov_fine = try values.decodeIfPresent(Int.self, forKey: .nov_fine)
		dec_fine = try values.decodeIfPresent(Int.self, forKey: .dec_fine)
		jan_fine = try values.decodeIfPresent(Int.self, forKey: .jan_fine)
		feb_fine = try values.decodeIfPresent(Int.self, forKey: .feb_fine)
		mar_fine = try values.decodeIfPresent(Int.self, forKey: .mar_fine)
	}

}
