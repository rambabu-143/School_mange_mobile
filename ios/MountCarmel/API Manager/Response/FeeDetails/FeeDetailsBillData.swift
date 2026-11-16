//
//  FeeDetailsBillData.swift
//  MountCarmel
//
//  Created by Sandip on 29/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class FeeDetailsBillData: WSResponseData {
    
    var _id : String?
    var strclass : String?
    var section : String?
    var section_id : String?
    var admission_no : String?
    var name : String?
    var mobile_no : String?
    var status : String?
    var session : String?
    var yearsession : String?
    var carry_forward_show : Bool?
    var date : String?
    var mode : String?
    var installmentNO : String?
    var time : String?
    var sch_code : String?
    var fees : FeeTypes?
    var concessionBoolean : Bool?
    var totalPayable : Int?
    var filepath : String?
    var standard_id : String?
    var installment : [FeeDetailsInstallment]?
    var payment_date : String?
    var next_payment_date : String?
    var totalNextPayable : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case strclass = "class"
        case section = "section"
        case section_id = "section_id"
        case admission_no = "admission_no"
        case name = "name"
        case mobile_no = "mobile_no"
        case status = "status"
        case session = "session"
        case yearsession = "year_session"
        case carry_forward_show = "carry_forward_show"
        case date = "date"
        case mode = "mode"
        case installmentNO = "installmentNO"
        case time = "time"
        case sch_code = "sch_code"
        case fees = "fees"
        case concessionBoolean = "concessionBoolean"
        case totalPayable = "totalPayable"
        case filepath = "filepath"
        case standard_id = "standard_id"
        case installment = "installment"
        case payment_date = "payment_date"
        case next_payment_date = "next_payment_date"
        case totalNextPayable = "totalNextPayable"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        strclass = try values.decodeIfPresent(String.self, forKey: .strclass)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        section_id = try values.decodeIfPresent(String.self, forKey: .section_id)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        mobile_no = try values.decodeIfPresent(String.self, forKey: .mobile_no)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        session = try values.decodeIfPresent(String.self, forKey: .session)
        yearsession = try values.decodeIfPresent(String.self, forKey: .yearsession)
        carry_forward_show = try values.decodeIfPresent(Bool.self, forKey: .carry_forward_show)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        mode = try values.decodeIfPresent(String.self, forKey: .mode)
        installmentNO = try values.decodeIfPresent(String.self, forKey: .installmentNO)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        sch_code = try values.decodeIfPresent(String.self, forKey: .sch_code)
        fees = try values.decodeIfPresent(FeeTypes.self, forKey: .fees)
        concessionBoolean = try values.decodeIfPresent(Bool.self, forKey: .concessionBoolean)
        totalPayable = try values.decodeIfPresent(Int.self, forKey: .totalPayable)
        filepath = try values.decodeIfPresent(String.self, forKey: .filepath)
        standard_id = try values.decodeIfPresent(String.self, forKey: .standard_id)
        installment = try values.decodeIfPresent([FeeDetailsInstallment].self, forKey: .installment)
        payment_date = try values.decodeIfPresent(String.self, forKey: .payment_date)
        next_payment_date = try values.decodeIfPresent(String.self, forKey: .next_payment_date)
        totalNextPayable = try values.decodeIfPresent(Int.self, forKey: .totalNextPayable)
    }
    
}
