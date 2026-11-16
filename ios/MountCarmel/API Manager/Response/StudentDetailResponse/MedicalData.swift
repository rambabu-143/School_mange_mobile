//
//  MedicalData.swift
//  MountCarmel
//
//  Created by Sandip on 25/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class MedicalData: Codable {
   /* var bloodgroup : String?
    var allergies : String?
    var weight : String?
    var height : String?
    var visionleft : String?
    var visionright : String?
    var teeth : String?
    var hygiene : String?
    var oralhygiene : String?
    var specificailment : String?
    var handicap : String?*/
    
    var allergies  : String?
    var bloodgroup : String?
    var bmi : String?
    var breath  : String?
    var dental_concerns  : String?
    var general_observation : String?
    var gums  : String?
    var handicap : String?
    var hearing  : String?
    var height  : String?
    var hygiene  : String?
    var lips  : String?
    var oralhygiene : String?;
    var other_observation : String?
    var physicaldisabilityyes  : String?
    var plaque : String?
    var specificailment : String?
    var teeth : String?
    var vision_left : String?
    var vision_right : String?
    //var visionleft  : String?
    //var visionright  : String?
    var weight  : String?
    
  /*  enum CodingKeys: String, CodingKey {
        
        case bloodgroup = "bloodgroup"
        case allergies = "allergies"
        case weight = "weight"
        case height = "height"
        case visionleft = "visionleft"
        case visionright = "visionright"
        case teeth = "teeth"
        case hygiene = "hygiene"
        case oralhygiene = "oralhygiene"
        case specificailment = "specificailment"
        case handicap = "handicap"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        bloodgroup = try values.decodeIfPresent(String.self, forKey: .bloodgroup)
        allergies = try values.decodeIfPresent(String.self, forKey: .allergies)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        height = try values.decodeIfPresent(String.self, forKey: .height)
        visionleft = try values.decodeIfPresent(String.self, forKey: .visionleft)
        visionright = try values.decodeIfPresent(String.self, forKey: .visionright)
        teeth = try values.decodeIfPresent(String.self, forKey: .teeth)
        hygiene = try values.decodeIfPresent(String.self, forKey: .hygiene)
        oralhygiene = try values.decodeIfPresent(String.self, forKey: .oralhygiene)
        specificailment = try values.decodeIfPresent(String.self, forKey: .specificailment)
        handicap = try values.decodeIfPresent(String.self, forKey: .handicap)
    }*/
    
}
