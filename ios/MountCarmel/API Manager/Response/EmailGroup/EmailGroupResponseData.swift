//
//  EmailGroupResponseData.swift
//  MountCarmel
//
//  Created by Sandip on 09/11/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation

class EmailGroupResponseData: WSResponseData {
    
    var email_group_file : String?

    enum CodingKeys: String, CodingKey {
        case email_group_file = "email_group_file"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email_group_file = try values.decodeIfPresent(String.self, forKey: .email_group_file)
    }
}
