//
//  TransportBillData.swift
//  MountCarmel
//
//  Created by Sandip on 28/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class TransportBillData: WSResponseData {
    var id : String?
    var strclass : String?
    var section : String?
    var pendingTransport : Int?
    var admission_no : String?
    var name : String?
    var transport_entryId : String?
    var status : String?
    var t_carry_forward_show : Bool?
    var session : String?
    var date : String?
    var time : String?
    var sch_code : String?
    var installmentNO : String?
    var yearsession : String?
    var transport_total_amt : Int?
    var busSecurity : String?
    var busSecurityAmt : Int?
    var payable : Int?
    var order : Int?
    var installment : [InstallmentData]?
    var allInstFine : Int?
    var firstPaymentOn : String?
    var filepath : String?
    var payment_date : String?
    var next_payable : Int?
    var next_payment_date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case strclass = "class"
        case section = "section"
        case pendingTransport = "pendingTransport"
        case admissionno = "admission_no"
        case name = "name"
        case transportentryId = "transport_entryId"
        case status = "status"
        case tcarryforwardshow = "t_carry_forward_show"
        case session = "session"
        case date = "date"
        case time = "time"
        case schcode = "sch_code"
        case installmentNO = "installmentNO"
        case yearsession = "yearsession"
        case transporttotalamt = "transport_total_amt"
        case busSecurity = "busSecurity"
        case busSecurityAmt = "busSecurityAmt"
        case payable = "payable"
        case order = "order"
        case installment = "installment"
        case allInstFine = "allInstFine"
        case firstPaymentOn = "firstPaymentOn"
        case filepath = "filepath"
        case paymentdate = "payment_date"
        case nextpayable = "next_payable"
        case nextpaymentdate = "next_payment_date"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        strclass = try values.decodeIfPresent(String.self, forKey: .strclass)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        pendingTransport = try values.decodeIfPresent(Int.self, forKey: .pendingTransport)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admissionno)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        transport_entryId = try values.decodeIfPresent(String.self, forKey: .transportentryId)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        t_carry_forward_show = try values.decodeIfPresent(Bool.self, forKey: .tcarryforwardshow)
        session = try values.decodeIfPresent(String.self, forKey: .session)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        sch_code = try values.decodeIfPresent(String.self, forKey: .schcode)
        installmentNO = try values.decodeIfPresent(String.self, forKey: .installmentNO)
        yearsession = try values.decodeIfPresent(String.self, forKey: .yearsession)
        transport_total_amt = try values.decodeIfPresent(Int.self, forKey: .transporttotalamt)
        busSecurity = try values.decodeIfPresent(String.self, forKey: .busSecurity)
        busSecurityAmt = try values.decodeIfPresent(Int.self, forKey: .busSecurityAmt)
        payable = try values.decodeIfPresent(Int.self, forKey: .payable)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
       // installment = try values.decodeIfPresent([InstallmentData].self, forKey: .installment)
        allInstFine = try values.decodeIfPresent(Int.self, forKey: .allInstFine)
        firstPaymentOn = try values.decodeIfPresent(String.self, forKey: .firstPaymentOn)
        filepath = try values.decodeIfPresent(String.self, forKey: .filepath)
        payment_date = try values.decodeIfPresent(String.self, forKey: .paymentdate)
        next_payable = try values.decodeIfPresent(Int.self, forKey: .nextpayable)
        next_payment_date = try values.decodeIfPresent(String.self, forKey: .nextpaymentdate)
    }

}
