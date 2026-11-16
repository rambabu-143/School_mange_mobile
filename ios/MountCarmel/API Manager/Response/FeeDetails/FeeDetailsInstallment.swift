//
//  FeeDetailsInstallment.swift
//  MountCarmel
//
//  Created by Sandip on 29/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class FeeDetailsInstallment: WSResponseData {
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
    var fine : Int?
    var amount_payble : Int?
    var fine_installment : Int?
    
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
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        inst_no = try values.decodeIfPresent(String.self, forKey: .instno)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        recived = try values.decodeIfPresent(String.self, forKey: .recived)
        instRecdAmtByDate = try values.decodeIfPresent(Int.self, forKey: .instRecdAmtByDate)
        installmentWithoutAny = try values.decodeIfPresent(Int.self, forKey: .installmentWithoutAny)
        receivedTillInstallment = try values.decodeIfPresent(Int.self, forKey: .receivedTillInstallment)
        allFineInInst = try values.decodeIfPresent(Int.self, forKey: .allFineInInst)
        singleInstalAmtNumber = try values.decodeIfPresent(Int.self, forKey: .singleInstalAmtNumber)
        totalToReceive = try values.decodeIfPresent(Int.self, forKey: .totalToReceive)
        recdate = try values.decodeIfPresent(String.self, forKey: .recdate)
        receipt = try values.decodeIfPresent(String.self, forKey: .receipt)
        cheq_no = try values.decodeIfPresent(String.self, forKey: .cheqno)
        fine = try values.decodeIfPresent(Int.self, forKey: .fine)
        amount_payble = try values.decodeIfPresent(Int.self, forKey: .amountpayble)
        fine_installment = try values.decodeIfPresent(Int.self, forKey: .fineinstallment)
    }
    
}
