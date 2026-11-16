//
//  ProfileDepartmentViewController.swift
//  MountCarmel
//
//  Created by Sandip on 07/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ProfileDepartmentViewController: UIViewController {
    
    @IBOutlet var lblStaffRoomTitle: UILabel!
    @IBOutlet var lblDepartmentTitle: UILabel!
    @IBOutlet var lblStaffRoomName: UILabel!
    @IBOutlet var lblDepName: UILabel!
    @IBOutlet weak var navigationView: NavigationBarView!
     var objProfileData : LoginAPIStaffId_Separate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Department"
        navigationView.delegate = self
        setUpData()
        // Do any additional setup after loading the view.
    }
    
    func setUpData(){
        
        self.lblDepartmentTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblStaffRoomTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        
        self.lblDepName.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblStaffRoomName.font = UIFont.setRegularFont(ofSize: 14.0)
        
        self.lblDepName.text = objProfileData?.departmentId?.name ?? ""
        self.lblStaffRoomName.text = objProfileData?.staffroomId?.roomNo ?? ""
    }
}

extension ProfileDepartmentViewController: NavigationBarViewDelegate {
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
    
    func onTapStory() {
        print(#function)
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
    
    func setHomeScreen() {
        if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
        }
    }
}
