//
//  GalleryAPIData.swift
//  MountCarmel
//
//  Created by Sandip on 12/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class GalleryAPIData: WSResponseData {
    var is_deleted : Bool?
    var _id : String?
    var year_session : String?
    var school_code : String?
    var photos : [Photos]?
    var gallery_name : String?
    var platform : String?
    var created_at : String?
    var event_date : String?
    var updated_at : String?
    var __v : Int?
    var description : String?
    
    enum CodingKeys: String, CodingKey {
        
        case is_deleted = "is_deleted"
        case _id = "_id"
        case year_session = "year_session"
        case school_code = "school_code"
        case photos = "images"
        case gallery_name = "name"
        case platform = "platform"
        case created_at = "created_at"
        case event_date = "event_date"
        case updated_at = "updated_at"
        case __v = "__v"
        case description = "description"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        year_session = try values.decodeIfPresent(String.self, forKey: .year_session)
        school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
        photos = try values.decodeIfPresent([Photos].self, forKey: .photos)
        gallery_name = try values.decodeIfPresent(String.self, forKey: .gallery_name)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        event_date = try values.decodeIfPresent(String.self, forKey: .event_date)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
}
