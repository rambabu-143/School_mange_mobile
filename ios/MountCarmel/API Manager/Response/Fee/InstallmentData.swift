//
//  InstallmentData.swift
//  MountCarmel
//
//  Created by Sandip on 28/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
enum DynamicStringOrInt: Codable {
    case int(Int)
    case string(String)
    
    var intValue: Int? {
       switch self {
       case .string(let s):
           return Int(s)
       case .int(let s):
           return s
       }
    }

    init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()

        // Decode the double
        do {
            let intVal = try container.decode(Int.self)
            self = .int(intVal)
        } catch DecodingError.typeMismatch {
            // Decode the string
            let stringVal = try container.decode(String.self)
            self = .string(stringVal)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}

class InstallmentData: WSResponseData {
    var type : String?
    var date : String?
    var inst_no : String?
    var amount : Int?
    var recived : String?
    var instRecdAmtByDate : Int?
    var installmentWithoutAny : Int?
    var receivedTillInstallment : Int?
    var allFineInInst : Int?
    var singleInstalAmtNumber : Int?
    var totalToReceive : Int?
    var recdate : String?
    var receipt : String?
    var cheq_no : String?
    var fine : DynamicStringOrInt?
    var amount_payble : Int?
    var fine_installment : Int?
    var installment_type : String?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case date = "date"
        case instno = "inst_no"
        case amount = "amount"
        case recived = "recived"
        case instRecdAmtByDate = "instRecdAmtByDate"
        case installmentWithoutAny = "installmentWithoutAny"
        case receivedTillInstallment = "receivedTillInstallment"
        case allFineInInst = "allFineInInst"
        case singleInstalAmtNumber = "singleInstalAmtNumber"
        case totalToReceive = "totalToReceive"
        case recdate = "recdate"
        case receipt = "receipt"
        case cheqno = "cheq_no"
        case fine = "fine"
        case amountpayble = "amount_payble"
        case fineinstallment = "fine_installment"
        case installment_type = "installment_type"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        inst_no = try values.decodeIfPresent(String.self, forKey: .instno)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        recived = try values.decodeIfPresent(String.self, forKey: .recived)
       // instRecdAmtByDate = try values.decodeIfPresent(Int.self, forKey: .instRecdAmtByDate)
        installmentWithoutAny = try values.decodeIfPresent(Int.self, forKey: .installmentWithoutAny)
        receivedTillInstallment = try values.decodeIfPresent(Int.self, forKey: .receivedTillInstallment)
        allFineInInst = try values.decodeIfPresent(Int.self, forKey: .allFineInInst)
        singleInstalAmtNumber = try values.decodeIfPresent(Int.self, forKey: .singleInstalAmtNumber)
        totalToReceive = try values.decodeIfPresent(Int.self, forKey: .totalToReceive)
        recdate = try values.decodeIfPresent(String.self, forKey: .recdate)
        receipt = try values.decodeIfPresent(String.self, forKey: .receipt)
        cheq_no = try values.decodeIfPresent(String.self, forKey: .cheqno)
        fine = try values.decodeIfPresent(DynamicStringOrInt.self, forKey: .fine)
        amount_payble = try values.decodeIfPresent(Int.self, forKey: .amountpayble)
        fine_installment = try values.decodeIfPresent(Int.self, forKey: .fineinstallment)
        installment_type = try values.decodeIfPresent(String.self, forKey: .installment_type)
    }

}
