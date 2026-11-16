//
//  SAPreviewViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 19/02/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit

class SAPreviewViewController: UIViewController {

    @IBOutlet weak var lblGoal: UILabel!
    @IBOutlet weak var lblStrength: UILabel!
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var lblResponsibilities: UILabel!
    
    
    internal var Goal = ""
    internal var Strength = ""
    internal var Interest = ""
    internal var Responsibilities = ""
    
    internal var callback: ((_ obj:Bool?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblGoal.text = Goal
        lblStrength.text = Strength
        lblInterest.text = Interest
        lblResponsibilities.text = Responsibilities
        
    }
    
    @IBAction func btnCross(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSaveDraft(_ sender: Any) {
        self.postSelfAwerness(submit: false)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.postSelfAwerness(submit: true)
    }
    
    
    private func postSelfAwerness(submit:Bool){
        let request = selfAwernessRequest(goals: Goal, strenth: Strength, interest: Interest, responsibilities: Responsibilities, submit: submit)
        Loader.show()
        StudentManagementAPI.selfAwerness(body: request) { (response, error) in
            Loader.hide()
            if response?.status == true {
                self.toast(response?.message ?? "")
                self.callback?(submit)
                self.dismiss(animated: true)
            }else{
                self.toast(response?.message ?? "")
            }
        }
    }
}
    

