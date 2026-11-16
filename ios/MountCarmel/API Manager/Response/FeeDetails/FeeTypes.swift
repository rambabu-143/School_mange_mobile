//
//  FeeTypes.swift
//  MountCarmel
//
//  Created by Sandip on 29/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class FeeTypes: WSResponseData {
    var combohead : [Combohead]?
    var monthlyFee : [MonthlyFee]?
    var annualFee : [AnnualFee]?
    var totals : Int?
    var pendingFee : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case combohead = "combohead"
        case monthlyFee = "monthlyFee"
        case annualFee = "annualFee"
        case totals = "totals"
        case pendingFee = "pendingFee"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        combohead = try values.decodeIfPresent([Combohead].self, forKey: .combohead)
        monthlyFee = try values.decodeIfPresent([MonthlyFee].self, forKey: .monthlyFee)
        annualFee = try values.decodeIfPresent([AnnualFee].self, forKey: .annualFee)
        totals = try values.decodeIfPresent(Int.self, forKey: .totals)
        pendingFee = try values.decodeIfPresent(Int.self, forKey: .pendingFee)
    }
}


