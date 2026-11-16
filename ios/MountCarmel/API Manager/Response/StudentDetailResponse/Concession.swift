//
//  FeesData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
class Concession : WSResponseData  {
	var concessionName : String?
	var concessionRemark : String?
	var monyhlyConcession : [ConssesionData]?
	var annualyConcession : [ConssesionData]?
	var currentDate : String?

	enum CodingKeys: String, CodingKey {

		case concessionName = "concessionName"
		case concessionRemark = "concessionRemark"
		case monyhlyConcession = "monyhlyConcession"
		case annualyConcession = "annualyConcession"
		case currentDate = "currentDate"
	}

	required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

		let values = try decoder.container(keyedBy: CodingKeys.self)
		concessionName = try values.decodeIfPresent(String.self, forKey: .concessionName)
		concessionRemark = try values.decodeIfPresent(String.self, forKey: .concessionRemark)
		monyhlyConcession = try values.decodeIfPresent([ConssesionData].self, forKey: .monyhlyConcession)
		annualyConcession = try values.decodeIfPresent([ConssesionData].self, forKey: .annualyConcession)
		currentDate = try values.decodeIfPresent(String.self, forKey: .currentDate)
	}

}

class ConssesionData : WSResponseData {
    var name : String?
    var charges : String?
    var concessionpercentage : String?
    var concessionamount : String?
    var amount : String?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case charges = "charges"
        case concessionpercentage = "concessionpercentage"
        case concessionamount = "concessionamount"
        case amount = "amount"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        charges = try values.decodeIfPresent(String.self, forKey: .charges)
        concessionpercentage = try values.decodeIfPresent(String.self, forKey: .concessionpercentage)
        concessionamount = try values.decodeIfPresent(String.self, forKey: .concessionamount)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
    }
    
}
