//
//  MCOP_Defaults.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 07/11/22.
//  Copyright © 2022 InventionHill. All rights reserved.
//

import Foundation

class MCOP_Defaults{
    static let shared = MCOP_Defaults()
    private init(){}
 
    var LoginToken: String? {
        get {return UserDefaults.standard.string(forKey: "LoginToken")}
        set {UserDefaults.standard.setValue(newValue, forKey: "LoginToken")
            UserDefaults.standard.synchronize()
        }
    }
}
