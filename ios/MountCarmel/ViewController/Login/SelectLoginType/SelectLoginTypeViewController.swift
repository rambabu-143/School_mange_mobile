//
//  SelectLoginTypeViewController.swift
//  MountCarmel
//
//  Created by Sandip on 20/03/21.
//  Copyright © 2021 InventionHill. All rights reserved.
//

import UIKit

class SelectLoginTypeViewController: UIViewController {

    @IBOutlet var lblStudent: UILabel!
    @IBOutlet var lblParent: UILabel!
    @IBOutlet var lblStaff: UILabel!
    @IBOutlet var lblLogin: UILabel!
    @IBOutlet var lblWelcome: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblWelcome.font = UIFont.setRegularFont(ofSize: 22.0)
        self.lblStudent.font = UIFont.setRegularFont(ofSize: 16.0)
        self.lblParent.font = UIFont.setRegularFont(ofSize: 16.0)
        self.lblStaff.font = UIFont.setRegularFont(ofSize: 16.0)
        self.lblLogin.font = UIFont.setRegularFont(ofSize: 19.0)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnStaffStudentLoginClick(_ sender: Any) {
//        if let vc: LoginViewController = LoginViewController.storyboardInstance.initialize() {
//            vc.modalPresentationStyle = .fullScreen
//            vc.isParentSelected = false
//            self.present(vc, animated: true, completion: nil)
//      }
        
        if let vc: LoginViewController = LoginViewController.storyboardInstance.initialize() {
            vc.isParentSelected = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnParentLoginClick(_ sender: Any) {
        if let vc: LoginViewController = LoginViewController.storyboardInstance.initialize() {
           // vc.modalPresentationStyle = .fullScreen
            vc.isParentSelected = true
           // let nav = UINavigationController()
            
            self.navigationController?.pushViewController(vc, animated: true)
           // self.present(vc, animated: true, completion: nil)
    }
  }
}
