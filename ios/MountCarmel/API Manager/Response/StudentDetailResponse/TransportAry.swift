

import Foundation
class TransportAry : WSResponseData {
	var morningroute : String?
	var morningstop : String?
	var morning_slabname : String?
	var eveningroute : String?
	var eveningstop : String?
	var evening_slabname : String?
	var transport_amt : Int?
	var tamt : Int?
	var mslabAmt : Int?
	var e_slabAmt : Int?
	var formonth : Int?

	enum CodingKeys: String, CodingKey {

		case morningroute = "morningroute"
		case morningstop = "morningstop"
		case morning_slabname = "morning_slabname"
		case eveningroute = "eveningroute"
		case eveningstop = "eveningstop"
		case evening_slabname = "evening_slabname"
		case transport_amt = "transport_amt"
		case tamt = "tamt"
		case mslabAmt = "mslabAmt"
		case e_slabAmt = "e_slabAmt"
		case formonth = "formonth"
	}

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		morningroute = try values.decodeIfPresent(String.self, forKey: .morningroute)
		morningstop = try values.decodeIfPresent(String.self, forKey: .morningstop)
		morning_slabname = try values.decodeIfPresent(String.self, forKey: .morning_slabname)
		eveningroute = try values.decodeIfPresent(String.self, forKey: .eveningroute)
		eveningstop = try values.decodeIfPresent(String.self, forKey: .eveningstop)
		evening_slabname = try values.decodeIfPresent(String.self, forKey: .evening_slabname)
		transport_amt = try values.decodeIfPresent(Int.self, forKey: .transport_amt)
		tamt = try values.decodeIfPresent(Int.self, forKey: .tamt)
		mslabAmt = try values.decodeIfPresent(Int.self, forKey: .mslabAmt)
		e_slabAmt = try values.decodeIfPresent(Int.self, forKey: .e_slabAmt)
		formonth = try values.decodeIfPresent(Int.self, forKey: .formonth)
	}

}
