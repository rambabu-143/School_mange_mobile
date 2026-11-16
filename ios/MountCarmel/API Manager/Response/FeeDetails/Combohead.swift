//
//  Combohead.swift
//  MountCarmel
//
//  Created by Sandip on 29/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class Combohead: WSResponseData {
    var combo_name : String?
    var combo_subject_amt : Int?
    var fee_code : String?
    var first_m : Int?
    var second_m : Int?
    var third_m : Int?
    var fourth_m : Int?
    var fifth_m : Int?
    var sixth_m : Int?
    var seventh_m : Int?
    var eighth_m : Int?
    var ninth_m : Int?
    var tenth_m : Int?
    var eleventh_m : Int?
    var twelth_m : Int?
    var first_m_wc : Int?
    var second_m_wc : Int?
    var third_m_wc : Int?
    var fourth_m_wc : Int?
    var fifth_m_wc : Int?
    var sixth_m_wc : Int?
    var seventh_m_wc : Int?
    var eighth_m_wc : Int?
    var ninth_m_wc : Int?
    var tenth_m_wc : Int?
    var eleventh_m_wc : Int?
    var twelth_m_wc : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case combo_name = "combo_name"
        case combo_subject_amt = "combo_subject_amt"
        case fee_code = "fee_code"
        case first_m = "first_m"
        case second_m = "second_m"
        case third_m = "third_m"
        case fourth_m = "fourth_m"
        case fifth_m = "fifth_m"
        case sixth_m = "sixth_m"
        case seventh_m = "seventh_m"
        case eighth_m = "eighth_m"
        case ninth_m = "ninth_m"
        case tenth_m = "tenth_m"
        case eleventh_m = "eleventh_m"
        case twelth_m = "twelth_m"
        case first_m_wc = "first_m_wc"
        case second_m_wc = "second_m_wc"
        case third_m_wc = "third_m_wc"
        case fourth_m_wc = "fourth_m_wc"
        case fifth_m_wc = "fifth_m_wc"
        case sixth_m_wc = "sixth_m_wc"
        case seventh_m_wc = "seventh_m_wc"
        case eighth_m_wc = "eighth_m_wc"
        case ninth_m_wc = "ninth_m_wc"
        case tenth_m_wc = "tenth_m_wc"
        case eleventh_m_wc = "eleventh_m_wc"
        case twelth_m_wc = "twelth_m_wc"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        combo_name = try values.decodeIfPresent(String.self, forKey: .combo_name)
        combo_subject_amt = try values.decodeIfPresent(Int.self, forKey: .combo_subject_amt)
        fee_code = try values.decodeIfPresent(String.self, forKey: .fee_code)
        first_m = try values.decodeIfPresent(Int.self, forKey: .first_m)
        second_m = try values.decodeIfPresent(Int.self, forKey: .second_m)
        third_m = try values.decodeIfPresent(Int.self, forKey: .third_m)
        fourth_m = try values.decodeIfPresent(Int.self, forKey: .fourth_m)
        fifth_m = try values.decodeIfPresent(Int.self, forKey: .fifth_m)
        sixth_m = try values.decodeIfPresent(Int.self, forKey: .sixth_m)
        seventh_m = try values.decodeIfPresent(Int.self, forKey: .seventh_m)
        eighth_m = try values.decodeIfPresent(Int.self, forKey: .eighth_m)
        ninth_m = try values.decodeIfPresent(Int.self, forKey: .ninth_m)
        tenth_m = try values.decodeIfPresent(Int.self, forKey: .tenth_m)
        eleventh_m = try values.decodeIfPresent(Int.self, forKey: .eleventh_m)
        twelth_m = try values.decodeIfPresent(Int.self, forKey: .twelth_m)
        first_m_wc = try values.decodeIfPresent(Int.self, forKey: .first_m_wc)
        second_m_wc = try values.decodeIfPresent(Int.self, forKey: .second_m_wc)
        third_m_wc = try values.decodeIfPresent(Int.self, forKey: .third_m_wc)
        fourth_m_wc = try values.decodeIfPresent(Int.self, forKey: .fourth_m_wc)
        fifth_m_wc = try values.decodeIfPresent(Int.self, forKey: .fifth_m_wc)
        sixth_m_wc = try values.decodeIfPresent(Int.self, forKey: .sixth_m_wc)
        seventh_m_wc = try values.decodeIfPresent(Int.self, forKey: .seventh_m_wc)
        eighth_m_wc = try values.decodeIfPresent(Int.self, forKey: .eighth_m_wc)
        ninth_m_wc = try values.decodeIfPresent(Int.self, forKey: .ninth_m_wc)
        tenth_m_wc = try values.decodeIfPresent(Int.self, forKey: .tenth_m_wc)
        eleventh_m_wc = try values.decodeIfPresent(Int.self, forKey: .eleventh_m_wc)
        twelth_m_wc = try values.decodeIfPresent(Int.self, forKey: .twelth_m_wc)
    }

}
