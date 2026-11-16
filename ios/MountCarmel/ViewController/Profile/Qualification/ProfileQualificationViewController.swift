//
//  ProfileQualificationViewController.swift
//  MountCarmel
//
//  Created by Sandip on 07/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ProfileQualificationViewController: UIViewController {

    @IBOutlet var tblView: UITableView!
    @IBOutlet weak var navigationView: NavigationBarView!
    var arrQualification = [LoginAPIQualification]()
    var objProfileData : LoginAPIStaffId_Separate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Qualification"
        navigationView.delegate = self
       // self.arrQualification = APP_DELEGATE.userInfo?.staffId?.qualification ?? [LoginAPIQualification]()
        self.tblView.reloadData()
        // Do any additional setup after loading the view.
    }
       
}
extension ProfileQualificationViewController: NavigationBarViewDelegate {
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
extension ProfileQualificationViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "ProfileQualificationCell", for: indexPath) as? ProfileQualificationCell
        cell?.lblSchoolName.text = objProfileData?.qualification ?? ""
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
