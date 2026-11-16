//
//  AllCardTypeData.swift
//  MountCarmel
//
//  Created by Sandip on 19/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import Foundation

class AllCardTypeData: WSResponseData {
    var worthy : Int?
    var intellect : Int?
    var stature : Int?
    var emotion : Int?
    var is_deleted : Bool?
    var _id : String?
    var id : Int?
    var adm_no : Int?
    var staff_id : StaffIDData?
    var staff_branch : String?
    var remarks : String?
    var reason : String?
    var card_type : String?
    var timestamp : String?
    var approved : String?
    var approvedby : String?
    var approval_timestamp : String?
    var card_entry_by : String?
    var parent_id : String?
    var chaap : String?
    var parent_card_id : Int?
    var status : Int?
    var admission_no : String?
    var school_code : String?
    var wise_date : String?
    var wise_updated : String?
    var created_at : String?
    var updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case worthy = "worthy"
        case intellect = "intellect"
        case stature = "stature"
        case emotion = "emotion"
        case is_deleted = "is_deleted"
        case _id = "_id"
        case id = "id"
        case adm_no = "adm_no"
        case staff_id = "staff_id"
        case staff_branch = "staff_branch"
        case remarks = "remarks"
        case reason = "reason"
        case card_type = "card_type"
        case timestamp = "timestamp"
        case approved = "approved"
        case approvedby = "approvedby"
        case approval_timestamp = "approval_timestamp"
        case card_entry_by = "card_entry_by"
        case parent_id = "parent_id"
        case chaap = "chaap"
        case parent_card_id = "parent_card_id"
        case status = "status"
        case admission_no = "admission_no"
        case school_code = "school_code"
        case wise_date = "wise_date"
        case wise_updated = "wise_updated"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
   required init(from decoder: Decoder) throws {
     try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        worthy = try values.decodeIfPresent(Int.self, forKey: .worthy)
        intellect = try values.decodeIfPresent(Int.self, forKey: .intellect)
        stature = try values.decodeIfPresent(Int.self, forKey: .stature)
        emotion = try values.decodeIfPresent(Int.self, forKey: .emotion)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        adm_no = try values.decodeIfPresent(Int.self, forKey: .adm_no)
        staff_id = try values.decodeIfPresent(StaffIDData.self, forKey: .staff_id)
        staff_branch = try values.decodeIfPresent(String.self, forKey: .staff_branch)
        remarks = try values.decodeIfPresent(String.self, forKey: .remarks)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        card_type = try values.decodeIfPresent(String.self, forKey: .card_type)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        approved = try values.decodeIfPresent(String.self, forKey: .approved)
        approvedby = try values.decodeIfPresent(String.self, forKey: .approvedby)
        approval_timestamp = try values.decodeIfPresent(String.self, forKey: .approval_timestamp)
        card_entry_by = try values.decodeIfPresent(String.self, forKey: .card_entry_by)
        parent_id = try values.decodeIfPresent(String.self, forKey: .parent_id)
        chaap = try values.decodeIfPresent(String.self, forKey: .chaap)
        parent_card_id = try values.decodeIfPresent(Int.self, forKey: .parent_card_id)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
        wise_date = try values.decodeIfPresent(String.self, forKey: .wise_date)
        wise_updated = try values.decodeIfPresent(String.self, forKey: .wise_updated)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}

class StaffIDData: WSResponseData {
   
    var id : String?
    var name : String?
   
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case name = "name"
        
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
       
    }
    
}
