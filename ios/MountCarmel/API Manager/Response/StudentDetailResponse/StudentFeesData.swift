//
//  FeesData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class StudentFeesData: WSResponseData {
    var combohead : [String]?
    var monthlyFee : [MonthlyFee]?
    var annualFee : [MonthlyFee]?
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
        
        
        combohead = try values.decodeIfPresent([String].self, forKey: .combohead)
        monthlyFee = try values.decodeIfPresent([MonthlyFee].self, forKey: .monthlyFee)
      //  annualFee = try values.decodeIfPresent([MonthlyFee].self, forKey: .annualFee)
        totals = try values.decodeIfPresent(Int.self, forKey: .totals)
        pendingFee = try values.decodeIfPresent(Int.self, forKey: .pendingFee)
    }

}

class FeesTypeData: WSResponseData {
    var admissionFee : [FeesTypeDetail]?
    var monthlyFee : [FeesTypeDetail]?
    var annualFee : [FeesTypeDetail]?
    var refundableFee : [FeesTypeDetail]?
    var totals : Int?
    var totalFee : TotalFee?
    var pendingFee : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case admissionFee = "admissionFee"
        case monthlyFee = "monthlyFee"
        case annualFee = "annualFee"
        case refundableFee = "refundableFee"
        case totalFee = "totalFee"
        case totals = "totals"
        case pendingFee = "pendingFee"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        admissionFee = try values.decodeIfPresent([FeesTypeDetail].self, forKey: .admissionFee)
        monthlyFee = try values.decodeIfPresent([FeesTypeDetail].self, forKey: .monthlyFee)
        annualFee = try values.decodeIfPresent([FeesTypeDetail].self, forKey: .annualFee)
//        refundableFee = try values.decodeIfPresent([FeesTypeDetail].self, forKey: .refundableFee)
        totalFee = try values.decodeIfPresent(TotalFee.self, forKey: .totalFee)
        totals = try values.decodeIfPresent(Int.self, forKey: .totals)
        pendingFee = try values.decodeIfPresent(Int.self, forKey: .pendingFee)
    }
    
}

class FeesTypeDetail: WSResponseData {
    var head_name : String?
    var head_value : String?
    
    enum CodingKeys: String, CodingKey {
        
        case head_name = "head_name"
        case headvalue = "head_value"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        head_name = try values.decodeIfPresent(String.self, forKey: .head_name)
        head_value = try values.decodeIfPresent(String.self, forKey: .headvalue)
       
    }
    
}

class TotalFee : WSResponseData {
    var admission_Fees : Int?
    var annual_Charges : Int?
    var refundable_Fees : Int?
    var monthly_Charges : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case admission_Fees = "Admission_Fees"
        case annual_Charges = "Annual_Charges"
        case refundable_Fees = "Refundable_Fees"
        case monthly_Charges = "Monthly_Charges"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        admission_Fees = try values.decodeIfPresent(Int.self, forKey: .admission_Fees)
        annual_Charges = try values.decodeIfPresent(Int.self, forKey: .annual_Charges)
        refundable_Fees = try values.decodeIfPresent(Int.self, forKey: .refundable_Fees)
        monthly_Charges = try values.decodeIfPresent(Int.self, forKey: .monthly_Charges)
    }
    
}
