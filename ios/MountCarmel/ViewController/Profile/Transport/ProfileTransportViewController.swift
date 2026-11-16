//
//  ProfileTransportViewController.swift
//  MountCarmel
//
//  Created by Sandip on 07/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ProfileTransportViewController: UIViewController {

    @IBOutlet var lblToTitle: UILabel!
    @IBOutlet var lblFromTitle: UILabel!
    @IBOutlet var lblPickUpTitle: UILabel!
    @IBOutlet var lblDropOffTitle: UILabel!
    @IBOutlet var lblEveningTitle: UILabel!
    @IBOutlet var lblMorningTitle: UILabel!
    @IBOutlet var lblTo: UILabel!
    @IBOutlet var lblFrom: UILabel!
    @IBOutlet var lblDropOff: UILabel!
    @IBOutlet var lblPickUp: UILabel!
    @IBOutlet var lblEvening: UILabel!
    @IBOutlet var lblMorning: UILabel!
    @IBOutlet weak var viewTransport: UIView!
    @IBOutlet weak var lblNoTransport: UILabel!
    
    @IBOutlet weak var viewFromTO: UIView!
    @IBOutlet weak var navigationView: NavigationBarView!
    var objGeneralProfileData : StudentDetailData?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Transport"
        navigationView.delegate = self
        
        self.lblMorningTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblEveningTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblDropOffTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblPickUpTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblFromTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblToTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        
        self.lblTo.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblFrom.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblDropOff.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblPickUp.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblEvening.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblMorning.font = UIFont.setRegularFont(ofSize: 14.0)
        
        setUpData()
        // Do any additional setup after loading the view.
    }
    
    func setUpData(){
        if(APP_DELEGATE.userType == .Staff){
            self.viewFromTO.isHidden = false
            var data = [LoginAPIRoutesDetail]()
            data = APP_DELEGATE.userInfo?.staffId?.transportId?.routesDetails ?? [LoginAPIRoutesDetail]()
            if(data.count > 0){
                self.lblNoTransport.isHidden = true
                self.lblMorning.text = data[0].mRouteId?.routeName ?? ""
                self.lblEvening.text = data[0].eRouteId?.routeName ?? ""
                self.lblPickUp.text = data[0].mTransportRouteStopId?.stopName ?? ""
                self.lblDropOff.text = data[0].eTransportRouteStopId?.stopName ?? ""
                
                self.lblFrom.text = getFromMonth(monthVal:data[0].mMonthFrom ?? 0)//data[0].mMonthFrom?
                self.lblTo.text = getToMonth(monthVal:data[0].eMonthTo ?? 0)//data[0].eMonthTo
            }else{
                //self.toast("No Transport Available")
                self.viewTransport.isHidden = true
            }
           
        }else{
            self.viewFromTO.isHidden = true
            if let data = objGeneralProfileData?.transport_bill_id?.transportAry?[0]{
                self.lblNoTransport.isHidden = true
                self.lblMorning.text = data.morningroute ?? ""
                self.lblEvening.text = data.eveningroute ?? ""
                self.lblPickUp.text = data.morningstop ?? ""
                self.lblDropOff.text = data.eveningstop ?? ""
                
                self.lblFrom.text = getFromMonth(monthVal:data.formonth ?? 0)//data[0].mMonthFrom?
                self.lblTo.text = getToMonth(monthVal:data.formonth ?? 0)//data[0].eMonthTo
            }else{
                //self.toast("No Transport Available")
                self.viewTransport.isHidden = true
            }
        }
        
    }
    
    //Here Month value 1 means April and 12 means March so we calculate month value by adding 3
    func getFromMonth(monthVal: Int) -> String{
        if(APP_DELEGATE.userType == .Staff){
            let monthNumber = monthVal + 3
            let fmt = DateFormatter()
            fmt.dateFormat = "MM"
            let month = fmt.monthSymbols[monthNumber - 1]
            print(month)
            return month
        }else{
            let fmt = DateFormatter()
            fmt.dateFormat = "MM"
            let month = fmt.monthSymbols[monthVal - 1]
            print(month)
            return month
        }
        //let monthNumber = monthVal + 3
        
    }
    
    //Here Month value 1 means April and 12 means March so we calculate month value = TotalMonthValue - (received from API + 3)
    func getToMonth(monthVal: Int) -> String{
        if(APP_DELEGATE.userType == .Staff){
            let monthNumber = (monthVal + 3) - 12
            let fmt = DateFormatter()
            fmt.dateFormat = "MM"
            let month = fmt.monthSymbols[monthNumber - 1]
            print(month)
            return month
        }else{
            let fmt = DateFormatter()
            fmt.dateFormat = "MM"
            let month = fmt.monthSymbols[monthVal - 1]
            print(month)
            return month
        }
        
        
    }

}
extension ProfileTransportViewController: NavigationBarViewDelegate {
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
