//
//  FeeBillData.swift
//  MountCarmel
//
//  Created by Sandip on 28/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class FeeBillData: WSResponseData {
    
    var id : String?
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
    var concessionBoolean : Bool?
    var totalPayable : Int?
    var filepath : String?
    var standard_id : String?
    var installment : [InstallmentData]?
    var payment_date : String?
    var next_payment_date : String?
    var totalNextPayable : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case strclass = "class"
        case section = "section"
        case sectionid = "section_id"
        case admissionno = "admission_no"
        case name = "name"
        case mobileno = "mobile_no"
        case status = "status"
        case session = "session"
        case yearsession = "yearsession"
        case carryforwardshow = "carry_forward_show"
        case date = "date"
        case mode = "mode"
        case installmentNO = "installmentNO"
        case time = "time"
        case schcode = "sch_code"
        case concessionBoolean = "concessionBoolean"
        case totalPayable = "totalPayable"
        case filepath = "filepath"
        case standardid = "standard_id"
        case installment = "installment"
        case paymentdate = "payment_date"
        case nextpaymentdate = "next_payment_date"
        case totalNextPayable = "totalNextPayable"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        strclass = try values.decodeIfPresent(String.self, forKey: .strclass)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        section_id = try values.decodeIfPresent(String.self, forKey: .sectionid)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admissionno)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        mobile_no = try values.decodeIfPresent(String.self, forKey: .mobileno)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        session = try values.decodeIfPresent(String.self, forKey: .session)
        yearsession = try values.decodeIfPresent(String.self, forKey: .yearsession)
        carry_forward_show = try values.decodeIfPresent(Bool.self, forKey: .carryforwardshow)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        mode = try values.decodeIfPresent(String.self, forKey: .mode)
        installmentNO = try values.decodeIfPresent(String.self, forKey: .installmentNO)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        sch_code = try values.decodeIfPresent(String.self, forKey: .schcode)
        concessionBoolean = try values.decodeIfPresent(Bool.self, forKey: .concessionBoolean)
        totalPayable = try values.decodeIfPresent(Int.self, forKey: .totalPayable)
        filepath = try values.decodeIfPresent(String.self, forKey: .filepath)
        standard_id = try values.decodeIfPresent(String.self, forKey: .standardid)
      //  installment = try values.decodeIfPresent([InstallmentData].self, forKey: .installment)
        payment_date = try values.decodeIfPresent(String.self, forKey: .paymentdate)
        next_payment_date = try values.decodeIfPresent(String.self, forKey: .nextpaymentdate)
        totalNextPayable = try values.decodeIfPresent(Int.self, forKey: .totalNextPayable)
    }

}
