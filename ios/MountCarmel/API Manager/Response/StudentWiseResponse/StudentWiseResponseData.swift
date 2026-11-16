//
//  StudentWiseResponseData.swift
//  MountCarmel
//
//  Created by Sandip on 19/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import Foundation
class StudentWiseResponseData: WSResponseData {
    var worthy : Worthy?
    var intellect : Intellect?
    var stature : Stature?
    var emotion : Emotion?
    
    enum CodingKeys: String, CodingKey {
        
        case worthy = "worthy"
        case intellect = "intellect"
        case stature = "stature"
        case emotion = "emotion"
    }
    
    required init(from decoder: Decoder) throws {
         try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        worthy = try values.decodeIfPresent(Worthy.self, forKey: .worthy)
        intellect = try values.decodeIfPresent(Intellect.self, forKey: .intellect)
        stature = try values.decodeIfPresent(Stature.self, forKey: .stature)
        emotion = try values.decodeIfPresent(Emotion.self, forKey: .emotion)
    }

}
