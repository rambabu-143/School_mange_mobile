//
//  Transport_BillData.swift
//  MountCarmel
//
//  Created by Sandip on 11/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class Transport_BillData: WSResponseData {
    
    var id : String?
    var order : Int?
    var strclass : String?
    var section : String?
    var pendingTransport : Int?
    var admission_no : String?
    var name : String?
    var transport_entryId : String?
    var status : String?
    var t_carry_forward_show : Bool?
    var session : String?
    var year_session : String?
    var date : String?
    var time : String?
    var school_code : String?
    var installmentNO : String?
    var transportAry : [TransportAry]?
    var transport_total_amt : Int?
    var busSecurity : String?
   // var busSecurityAmt : Int?
    var payable : Int?
    var installment : [Installment]?
    var allInstFine : Int?
    var filepath : String?
    var standard_id : String?
    var section_id : String?
    var full_payment_received : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case order = "order"
        case strclass = "class"
        case section = "section"
        case pendingTransport = "pendingTransport"
        case admission_no = "admission_no"
        case name = "name"
        case transport_entryId = "transport_entryId"
        case status = "status"
        case t_carry_forward_show = "t_carry_forward_show"
        case session = "session"
        case year_session = "year_session"
        case date = "date"
        case time = "time"
        case school_code = "school_code"
        case installmentNO = "installmentNO"
        case transportAry = "transportAry"
        case transport_total_amt = "transport_total_amt"
        case busSecurity = "busSecurity"
       // case busSecurityAmt = "busSecurityAmt"
        case payable = "payable"
        case installment = "installment"
        case allInstFine = "allInstFine"
        case filepath = "filepath"
        case standard_id = "standard_id"
        case section_id = "section_id"
        case full_payment_received = "full_payment_received"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
       // id = try values.decodeIfPresent(String.self, forKey: ._id)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
        strclass = try values.decodeIfPresent(String.self, forKey: .strclass)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        pendingTransport = try values.decodeIfPresent(Int.self, forKey: .pendingTransport)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        transport_entryId = try values.decodeIfPresent(String.self, forKey: .transport_entryId)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        t_carry_forward_show = try values.decodeIfPresent(Bool.self, forKey: .t_carry_forward_show)
        session = try values.decodeIfPresent(String.self, forKey: .session)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
        installmentNO = try values.decodeIfPresent(String.self, forKey: .installmentNO)
        transportAry = try values.decodeIfPresent([TransportAry].self, forKey: .transportAry)
        transport_total_amt = try values.decodeIfPresent(Int.self, forKey: .transport_total_amt)
        busSecurity = try values.decodeIfPresent(String.self, forKey: .busSecurity)
       // busSecurityAmt = try values.decodeIfPresent(Int.self, forKey: .busSecurityAmt)
        payable = try values.decodeIfPresent(Int.self, forKey: .payable)
        installment = try values.decodeIfPresent([Installment].self, forKey: .installment)
        allInstFine = try values.decodeIfPresent(Int.self, forKey: .allInstFine)
        filepath = try values.decodeIfPresent(String.self, forKey: .filepath)
        standard_id = try values.decodeIfPresent(String.self, forKey: .standard_id)
        section_id = try values.decodeIfPresent(String.self, forKey: .section_id)
        full_payment_received = try values.decodeIfPresent(Bool.self, forKey: .full_payment_received)
    }
    
}


class Installment : WSResponseData {
    var type : String?
    var date : String?
    var inst_no : String?
    var amount : Int?
    var recived : String?
    var recdate : String?
    var receipt : String?
    var cheq_no : String?
    var amount_payble : Int?
    var docno : String?
    var fine : Int?
    var amtWithoutFine : Int?
    var year_session : String?
    var installment_type  : String?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case date = "date"
        case inst_no = "inst_no"
        case amount = "amount"
        case recived = "recived"
        case recdate = "recdate"
        case receipt = "receipt"
        case cheq_no = "cheq_no"
        case amount_payble = "amount_payble"
        case docno = "docno"
        case fine = "fine"
        case amtWithoutFine = "amtWithoutFine"
        case year_session = "year_session"
        case installment_type = "installment_type"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        inst_no = try values.decodeIfPresent(String.self, forKey: .inst_no)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        recived = try values.decodeIfPresent(String.self, forKey: .recived)
        recdate = try values.decodeIfPresent(String.self, forKey: .recdate)
        receipt = try values.decodeIfPresent(String.self, forKey: .receipt)
        cheq_no = try values.decodeIfPresent(String.self, forKey: .cheq_no)
        amount_payble = try values.decodeIfPresent(Int.self, forKey: .amount_payble)
        docno = try values.decodeIfPresent(String.self, forKey: .docno)
        fine = try values.decodeIfPresent(Int.self, forKey: .fine)
        amtWithoutFine = try values.decodeIfPresent(Int.self, forKey: .amtWithoutFine)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
        installment_type = try values.decodeIfPresent(String.self, forKey: .installment_type)
    }
    
}
