//
//  Loader.swift
//  MountCarmel
//
//  Created by Chauhan Ramdevsinh on 23/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import SVProgressHUD

class Loader {
    class func show(title: String? = nil, icon: UIImage? = nil) {
        SVProgressHUD.setDefaultMaskType(.black)
        
        if let icon = icon {
            SVProgressHUD.show(icon, status: title)
        } else {
            SVProgressHUD.show(withStatus: title)
        }
    }
    
    class func hide() {
        SVProgressHUD.dismiss()
    }
}

