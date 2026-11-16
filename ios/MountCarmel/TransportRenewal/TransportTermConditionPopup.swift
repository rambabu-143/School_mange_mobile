//
//  TransportTermConditionPopup.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 02/06/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit

class TransportTermConditionPopup: UIViewController {

    var submitHandler : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if(self.submitHandler != nil){
            self.submitHandler!()
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
