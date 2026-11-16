//
//  ChildListViewController.swift
//  MountCarmel
//
//  Created by Sandip on 05/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ChildListViewController: UIViewController {
    @IBOutlet var tblChildList: UITableView!
    @IBOutlet weak var navigationView: NavigationBarView!
    var arrTitle = ["Prabal Singh","Adhya Rangarajan","Akshita Dogra","Viraj Verma","Avijit Rai","TheJangutso Mere"]
    
    var arrStudents = [LoginAPIStudent]()
    var isFromProfile = false
    var objGeneralProfileData : StudentDetailData?
    var imgPath = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Child"
        navigationView.delegate = self
        setInitialView()
        self.arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        self.tblChildList.reloadData()
        if (isFromProfile){
            if APP_DELEGATE.userType == LoginType.Nursery || APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent {
                navigationView.lblTitle.text = "Sibling"
                if objGeneralProfileData?.siblings?.count == 0{
                    self.toast("No Siblings Found")
                }
            }
        }
    }

    func setInitialView(){
        tblChildList.register(UINib(nibName: "ChildListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChildListTableViewCell")
    }

}
extension ChildListViewController: NavigationBarViewDelegate {
    
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
extension ChildListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromProfile{
            if APP_DELEGATE.userType == LoginType.Nursery || APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent {
                return objGeneralProfileData?.siblings?.count ?? 0
            }
        }
        return self.arrStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblChildList.dequeueReusableCell(withIdentifier: "ChildListTableViewCell", for: indexPath) as? ChildListTableViewCell
       // cell?.lblIndex.text = "\(indexPath.row + 1)"
        if isFromProfile{
            if APP_DELEGATE.userType == LoginType.Nursery || APP_DELEGATE.userType == LoginType.School || APP_DELEGATE.userType == LoginType.Parent {
                
                cell?.lblName.text = objGeneralProfileData?.siblings?[indexPath.row].sibling_id?.name ?? ""
                
                cell?.lblID.text = objGeneralProfileData?.siblings?[indexPath.row].sibling_id?.admissionNo ?? ""
                
                cell?.lblID.font = UIFont.setRegularFont(ofSize: 15)
                cell?.lblName.font = UIFont.setBoldFont(ofSize: 15)
                
                let strClass = (objGeneralProfileData?.siblings?[indexPath.row].sibling_id?.standardId?.name ?? "") + "-" +
                    (objGeneralProfileData?.siblings?[indexPath.row].sibling_id?.sectionId?.name ?? "")
                cell?.btnClass.setTitle("class: \(strClass)", for: .normal)
                
                let imageURL = imgPath + (objGeneralProfileData?.siblings?[indexPath.row].sibling_id?.profile_pic ?? "")
                cell?.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
                
            }
        }
        else{
            cell?.lblName.text = self.arrStudents[indexPath.row].studentId?.name ?? ""
            let strClass = (self.arrStudents[indexPath.row].studentId?.standardId?.name ?? "") + "-" +
                (self.arrStudents[indexPath.row].studentId?.sectionId?.name ?? "")
            cell?.btnClass.setTitle("class: \(strClass)", for: .normal)
            cell?.imgProfile?.image = UIImage(named: "s-\(indexPath.row+1)")
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

