//
//  LoginAPISlabID.swift
//  MountCarmel
//
//  Created by Sandip on 07/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class LoginAPISlabID: WSResponseData {
    
    var slabname : String?
    
    
    enum CodingKeys: String, CodingKey {
        case slabname = "slab_name"
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slabname = try values.decodeIfPresent(String.self, forKey: .slabname)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(slabname, forKey: .slabname)
    }
}
