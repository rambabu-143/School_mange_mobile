//
//  FeeDetailData.swift
//  MountCarmel
//
//  Created by Sandip on 29/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class FeeDetailData: WSResponseData {
    var admission_no : String?
    var feebillid : FeeDetailsBillData?

    enum CodingKeys: String, CodingKey {
        
        case admissionno = "admission_no"
        case feebillid = "fee_bill_id"

    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admissionno)
        feebillid = try values.decodeIfPresent(FeeDetailsBillData.self, forKey: .feebillid)
    }
}


