//
//  MedicalViewController.swift
//  MountCarmel
//
//  Created by Sandip on 26/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class MedicalViewController: UIViewController {

    @IBOutlet var lblTitles: [UILabel]!
    @IBOutlet weak var lblTitleOralHygiene: UILabel!
    
    @IBOutlet weak var lblBloodGroup: UILabel!
    @IBOutlet weak var lblAllergies: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblBMI: UILabel!
    @IBOutlet weak var lblVisionLeft: UILabel!
    @IBOutlet weak var lblVisionRight: UILabel!
    @IBOutlet weak var lblHearing: UILabel!
    @IBOutlet weak var lblLips: UILabel!
    @IBOutlet weak var lblTeeth: UILabel!
    @IBOutlet weak var lblPleque: UILabel!
    @IBOutlet weak var lblGums: UILabel!
    @IBOutlet weak var lblBreath: UILabel!
    @IBOutlet weak var lblDentalConcern: UILabel!
    @IBOutlet weak var lblGeneralObservation: UILabel!
    @IBOutlet weak var lblOtherObservation: UILabel!
    @IBOutlet weak var lblSpecialAilments: UILabel!
    
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var btnEdit: UIButton!
    
     var objGeneralProfileData : StudentDetailData?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Health"
        navigationView.delegate = self
        setAppFontAndData()
        
        btnEdit.isHidden = !(APP_DELEGATE.userType == LoginType.Parent)
        // Do any additional setup after loading the view.
    }
    
    func setAppFontAndData(){
        // ------ School Information ---- //
        for lbl in lblTitles{
            lbl.font = UIFont.setRegularFont(ofSize: 13.0)
        }
        self.lblTitleOralHygiene.font = UIFont.setBoldFont(ofSize: 13.0)
        
        self.lblBloodGroup.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblAllergies.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblHeight.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblWeight.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblBMI.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblVisionLeft.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblVisionRight.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblHearing.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblLips.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblTeeth.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblPleque.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblGums.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblBreath.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblDentalConcern.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblGeneralObservation.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblOtherObservation.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblSpecialAilments.font = UIFont.setRegularFont(ofSize: 14.0)
        
        if let healthData = objGeneralProfileData?.medical {
           /* self.lblAllergiesVal.text = healthData.allergies ?? ""
            self.lblBloodGroupVal.text = healthData.bloodgroup ?? ""
            self.lblSpecificAilmentsVal.text = healthData.specificailment ?? ""
            self.lblweightVal.text = healthData.weight ?? ""
            self.lblHeightVal.text = healthData.height ?? ""
            self.lbloralHygineVal.text = healthData.oralhygiene ?? ""
            self.lblHygineVal.text = healthData.hygiene ?? ""
            self.lblVisionRightVal.text = healthData.visionright ?? ""
             self.lblVleftVal.text = healthData.visionleft ?? ""
            self.lblTeethVal.text = healthData.teeth ?? ""*/
            
            self.lblBloodGroup.text = healthData.bloodgroup ?? ""
            self.lblAllergies.text = healthData.allergies ?? ""
            self.lblHeight.text = healthData.height ?? ""
            self.lblWeight.text = healthData.weight ?? ""
            self.lblBMI.text = healthData.bmi ?? ""
            self.lblVisionLeft.text = healthData.vision_left ?? ""
            self.lblVisionRight.text = healthData.vision_right ?? ""
            self.lblHearing.text = healthData.hearing ?? ""
            self.lblLips.text = healthData.lips ?? ""
            self.lblTeeth.text = healthData.teeth ?? ""
            self.lblPleque.text = healthData.plaque ?? ""
            self.lblGums.text = healthData.gums ?? ""
            self.lblBreath.text = healthData.breath ?? ""
            self.lblDentalConcern.text = healthData.dental_concerns ?? ""
            self.lblGeneralObservation.text = healthData.general_observation ?? ""
            self.lblOtherObservation.text = healthData.other_observation ?? ""
            self.lblSpecialAilments.text = healthData.specificailment ?? ""
        }
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        let vc = UIStoryboard(name: "MedicalViewController", bundle: nil).instantiateViewController(withIdentifier: "EditMedicalViewController") as! EditMedicalViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.Blood = lblBloodGroup.text!
        vc.Allergies = lblAllergies.text!
        vc.submitHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        self.present(vc, animated: true)
    }
    
}

extension MedicalViewController: NavigationBarViewDelegate {
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
