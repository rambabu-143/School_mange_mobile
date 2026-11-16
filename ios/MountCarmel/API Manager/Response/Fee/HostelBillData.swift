//
//  HostelBillData.swift
//  MountCarmel
//
//  Created by Sandip on 28/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class HostelBillData: WSResponseData {
    var id : String?
    var strclass : String?
    var section : String?
    var section_id : String?
    var admission_no : String?
    var name : String?
    var mobile_no : String?
    var status : String?
    var yearsession : String?
    var date : String?
    var mode : String?
    var installmentNO : String?
    var time : String?
    var installment : [InstallmentData]?
    var sch_code : String?
    var totalPayable : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case strclass = "class"
        case section = "section"
        case sectionid = "section_id"
        case admissionno = "admission_no"
        case name = "name"
        case mobileno = "mobile_no"
        case status = "status"
        case yearsession = "yearsession"
        case date = "date"
        case mode = "mode"
        case installmentNO = "installmentNO"
        case time = "time"
        case installment = "installment"
        case schcode = "sch_code"
        case totalPayable = "totalPayable"
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
        yearsession = try values.decodeIfPresent(String.self, forKey: .yearsession)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        mode = try values.decodeIfPresent(String.self, forKey: .mode)
        installmentNO = try values.decodeIfPresent(String.self, forKey: .installmentNO)
        time = try values.decodeIfPresent(String.self, forKey: .time)
       // installment = try values.decodeIfPresent([InstallmentData].self, forKey: .installment)
        sch_code = try values.decodeIfPresent(String.self, forKey: .schcode)
        totalPayable = try values.decodeIfPresent(Int.self, forKey: .totalPayable)
    }

}
