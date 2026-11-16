//
//  SelfAwarenessFormViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 18/02/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit
import DTTextField
class SelfAwarenessFormViewController: UIViewController {
    @IBOutlet weak var lastSubmissionDate: UILabel!
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var txtGoals: DTTextField!{
        didSet{
            //txtGoals.addTarget(self, action: #selector(textGoals(textField:)), for: .editingChanged)
            txtGoals.delegate = self
        }
    }
    @IBOutlet weak var txtStrength: DTTextField!{
        didSet{
            //txtStrength.addTarget(self, action: #selector(textStrength(textField:)), for: .editingChanged)
            txtStrength.delegate = self
        }
    }
    @IBOutlet weak var txtInterest: DTTextField!{
        didSet{
            //txtInterest.addTarget(self, action: #selector(textInterest(textField:)), for: .editingChanged)
            txtInterest.delegate = self
        }
    }
    @IBOutlet weak var txtResponsibilities: DTTextField!{
        didSet{
            //txtResponsibilities.addTarget(self, action: #selector(textResponsibilities(textField:)), for: .editingChanged)
            txtResponsibilities.delegate = self
        }
    }
    
    @IBOutlet weak var lblMyGoales: UILabel!{didSet{}}
    @IBOutlet weak var lblMyStrength: UILabel!{didSet{}}
    @IBOutlet weak var lblMyInterest: UILabel!{didSet{}}
    @IBOutlet weak var lblMyResponsibilities: UILabel!{didSet{}}
    
    @IBOutlet weak var lblSubmittedGoales: UILabel!
    @IBOutlet weak var lblSubmittedStrength: UILabel!
    @IBOutlet weak var lblSubmittedInterest: UILabel!
    @IBOutlet weak var lblSubmittedResponsibilities: UILabel!
    
    @IBOutlet weak var viewSubmitted: UIView!{
        didSet{
            viewSubmitted.isHidden = true
        }
    }
   private let maxLength = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.lblTitle.text = "Self Awareness"
        navigationView.delegate = self
              
        self.view.isHidden = true
        self.callAPIForGetSelfAwerness { success in
            self.view.isHidden = false
        }
    }
    
    @IBAction func btnPreview(_ sender: Any) {
        let vc = UIStoryboard(name: "SelfAwarenessFormViewController", bundle: nil).instantiateViewController(withIdentifier: "SAPreviewViewController") as! SAPreviewViewController
        vc.Goal = txtGoals.text!
        vc.Strength = txtStrength.text!
        vc.Interest = txtInterest.text!
        vc.Responsibilities = txtResponsibilities.text!
        
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.callback = { (obj) -> Void in
            self.callAPIForGetSelfAwerness { success in
          }
       }
        
        self.present(vc, animated: true)
    }
    
   private func callAPIForGetSelfAwerness(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
       
       StudentManagementAPI.getSelfAwerness { data, error in
           Loader.hide()
           guard let response = data else{
               self.toast(error?.localizedDescription ?? "Invalid response")
               finished(false)
               return
           }
           print(response)
          
           if (response.data?.is_submit ?? false) == true{
               self.navigationView.lblTitle.text = "Self Awareness"
               self.viewSubmitted.isHidden = false
               self.lblSubmittedGoales.text = response.data?.my_goal ?? ""
               self.lblSubmittedStrength.text = response.data?.my_strength ?? ""
               self.lblSubmittedInterest.text = response.data?.my_interest_hobbies ?? ""
               self.lblSubmittedResponsibilities.text = response.data?.responsibilities ?? ""
                              
               //self.lastSubmissionDate.text = "Last Date of Submission : " + CommonFunctions.UTCToLocal(date: response.data?.updated_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Notice)
           }else{
               
               self.viewSubmitted.isHidden = true
               self.txtGoals.text = response.data?.my_goal ?? ""
               self.txtStrength.text = response.data?.my_strength ?? ""
               self.txtInterest.text = response.data?.my_interest_hobbies ?? ""
               self.txtResponsibilities.text = response.data?.responsibilities ?? ""
               
               self.lblMyGoales.text =  "\(self.textcount(str: self.txtGoals.text!))/\(self.maxLength)"
               self.lblMyStrength.text =  "\(self.textcount(str: self.txtStrength.text!))/\(self.maxLength)"
               self.lblMyInterest.text = "\(self.textcount(str: self.txtInterest.text!) )/\(self.maxLength)"
               self.lblMyResponsibilities.text =  "\(self.textcount(str: self.txtResponsibilities.text!))/\(self.maxLength)"
           }
           
           let date = CommonFunctions.UTCToLocal(date: response.golive_data?.end_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_selfAwareness1)
           
           //let time = CommonFunctions.UTCToLocal(date: response.golive_data?.end_time ?? "", fromFormat: DateFormat.HHmm, toFormat: DateFormat.DateFormat_selfAwareness2)
           let time = (response.golive_data?.end_time ?? "") + ":00"
           
           self.lastSubmissionDate.text = "Last Date of Submission: " + date + " | " + time
           
           finished(true)
       }
              
    }
    
}

extension SelfAwarenessFormViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        let flag = newString.count <= maxLength
        if flag{
            let count = textcount(str: newString)
            switch textField{
            case txtGoals:
                lblMyGoales.text = "\(count)/\(maxLength)"
                break;
            case txtStrength:
                lblMyStrength.text = "\(count)/\(maxLength)"
                break;
            case txtInterest:
                lblMyInterest.text = "\(count)/\(maxLength)"
                break;
            case txtResponsibilities:
                lblMyResponsibilities.text = "\(count)/\(maxLength)"
                break;
            default :
                break;
            }
        }
       
        return flag
    }
    
    private func textcount(str:String)->String{
        return String(str.count)
    }
}
extension SelfAwarenessFormViewController: NavigationBarViewDelegate{
    func onTapDropDown() {
    }
    func onTapMenu() {
    }
    
    func onTapBack() {
        if self.navigationController?.viewControllers.count ?? 0 == 1 {
            self.setHomeScreen()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onTapNotification() {
        if let viewController: NotificationViewController = NotificationViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func onTapBadgeCounts() {
        if let viewController: NotificationViewController = NotificationViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func onTapAppLogo() {
        let viewcontrollers = self.navigationController?.viewControllers
        var flag = true
        viewcontrollers?.forEach({ (vc) in
            if  let viewController = vc as? HomeViewController {
                flag = false
                self.navigationController!.popToViewController(viewController, animated: true)
            }
        })
        if flag {
            self.setHomeScreen()
        }
    }
    func onTapStory() {
        print(#function)
    }
    func setHomeScreen() {
        if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
        }
    }
}
