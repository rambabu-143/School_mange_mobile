//
//  TransportWithdrawViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 01/02/24.
//  Copyright © 2024 InventionHill. All rights reserved.
//

import UIKit

class TransportWithdrawViewController: UIViewController {
    
    @IBOutlet weak var lbl: UILabel!
    var submitHandler : (() -> ())?
    internal var year = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let fy = year.split(separator: "-").first ?? ""
        lbl.text = "I hereby accept and confirm that the school transport facility for my ward be withdrawn w.e.f 1st April \(fy) for the session \(year)."
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
