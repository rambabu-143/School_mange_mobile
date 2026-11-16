//
//  Photos.swift
//  MountCarmel
//
//  Created by Sandip on 12/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class Photos: WSResponseData {
    var _id : String?
    var filename : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case filename = "file_name"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        filename = try values.decodeIfPresent(String.self, forKey: .filename)
    }
}
