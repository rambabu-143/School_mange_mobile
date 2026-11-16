//
//  FeesData.swift
//  MountCarmel
//
//  Created by Sandip on 28/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class FeesData: WSResponseData {
    var admission_no : String?
    var feebillid : FeeBillData?
    var transport_bill_id : TransportBillData?
    var hostel_bill_id : HostelBillData?
    
    enum CodingKeys: String, CodingKey {
        
        case admissionno = "admission_no"
        case feebillid = "fee_bill_id"
        case transportbillid = "transport_bill_id"
        case hostelbillid = "hostel_bill_id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admissionno)
        feebillid = try values.decodeIfPresent(FeeBillData.self, forKey: .feebillid)
        transport_bill_id = try values.decodeIfPresent(TransportBillData.self, forKey: .transportbillid)
        hostel_bill_id = try values.decodeIfPresent(HostelBillData.self, forKey: .hostelbillid)
    }
}


