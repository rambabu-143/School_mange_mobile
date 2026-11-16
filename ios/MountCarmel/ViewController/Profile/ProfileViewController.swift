//
//  ProfileViewController.swift
//  MountCarmel
//
//  Created by Sandip on 04/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblnumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet var imgProfileIcon: RoundedImage!
    @IBOutlet var imgProfileBack: UIImageView!
    @IBOutlet var profileCollectionView: UICollectionView!
    
    @IBOutlet weak var btnEdit: RoundedButton!{
        didSet{
            if(APP_DELEGATE.userType != LoginType.Staff){
                btnEdit.isHidden = true
        }}}
    
    @IBOutlet weak var navigationView: NavigationBarView!
    
     var arrTitle = ["General","Transport","Qualification","Department"]
    var objProfileData : StudentDetailData?
    var objStaffProfileData : LoginAPIStaffId_Separate?
    var imgURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        navigationView.lblTitle.text = "Profile"
        navigationView.delegate = self        
        
        
        if(APP_DELEGATE.userType == LoginType.Parent){
            arrTitle = ["General","Parent","Health","Sibling","Transport"]
        }else{
            arrTitle = ["General","Transport","Qualification","Department"]
        }
      
        
        self.lblName.font = UIFont.setRegularFont(ofSize: 15.0)
        self.lblnumber.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblCode.font = UIFont.setRegularFont(ofSize: 13.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUpInitialData()
    }
    func setUpInitialData(){
        let nibOfDashboardCell = UINib.init(nibName: "ProfileDepartmentCell", bundle: Bundle.main)
        profileCollectionView.register(nibOfDashboardCell, forCellWithReuseIdentifier: "ProfileDepartmentCell")
        
        profileCollectionView.reloadData()
        
        if APP_DELEGATE.userType == LoginType.Staff{
            self.callAPIStaffDetails { (check, responseData) in
                if(check){
                    self.objStaffProfileData = responseData?.data
                    self.imgURL = responseData?.path ?? ""
                    
                    self.setData()
                }
            }
        }else{
            self.callAPIStudentDetails { (check, objData) in
                if(check){
                    self.objProfileData = objData?.data
                    self.imgURL = objData?.path ?? ""
                    
                    self.setData()
                }
            }
        }
    }
    
    private func setData(){
        if APP_DELEGATE.userType == LoginType.Nursery || APP_DELEGATE.userType == LoginType.School {
            self.lblnumber.isHidden = true
            
             arrTitle = ["General","Parent","Health","Sibling"]

            let userInfo = APP_DELEGATE.userInfo
           // let urlPath = APP_DELEGATE.urlPath
           // let imageURL = urlPath + (userInfo?.profilePic ?? "")
            //studentImageIssue
            
            let imageURL = (imgURL)+(objProfileData?.profile_pic ?? "")
            
            self.imgProfileBack.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
            
             self.imgProfileIcon.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
            self.lblName.text = userInfo?.name
            let arrStudents = userInfo?.students ?? [LoginAPIStudent]()
            if(arrStudents.count > 0){
                self.lblCode.text = (arrStudents[0].studentId?.standardId?.name ?? "") + "-" + (arrStudents[0].studentId?.sectionId?.name ?? "")
            }else{
                self.lblCode.text = ""
            }
            
        }else if APP_DELEGATE.userType == LoginType.Staff {
            self.lblnumber.isHidden = false
            self.lblName.text = APP_DELEGATE.userInfo?.name
            self.lblCode.text = APP_DELEGATE.loginAPIResponse?.metaData?.schoolCode
            self.lblnumber.text = APP_DELEGATE.userInfo?.mobile
            
            let userInfo = APP_DELEGATE.userInfo
            let urlPath = APP_DELEGATE.urlPath + "/"
            let imageURL = urlPath + (userInfo?.staffId?.profile_pic ?? "")
            self.imgProfileIcon.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
            self.imgProfileBack.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
            
            
        }else if APP_DELEGATE.userType == LoginType.Parent {
            self.lblnumber.isHidden = false
            self.lblCode.isHidden = true
            let userInfo = APP_DELEGATE.userInfo
            _ = APP_DELEGATE.urlPath
           // let imageURL = urlPath + (userInfo?.profilePic ?? "")
            //studentImageIssue
            let imageURL = (imgURL)+(objProfileData?.profile_pic ?? "")
            self.imgProfileBack.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
            
            self.imgProfileIcon.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
           
            self.lblName.text = userInfo?.name
            self.lblnumber.text = userInfo?.mobile
            
            // let arrStudents = APP_DELEGATE.selected_Student
            
           // self.lblCode.text = (APP_DELEGATE.selected_Student?.studentId?.standardId?.name ?? "") + "-" + (APP_DELEGATE.selected_Student?.studentId?.sectionId?.name ?? "")
        }
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        let vc = UIStoryboard(name: "ProfileViewController", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        vc.objStaffProfileData = self.objStaffProfileData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileViewController: NavigationBarViewDelegate {
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
extension ProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileDepartmentCell", for: indexPath) as! ProfileDepartmentCell
        cell.lblTitle.text = arrTitle[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: (collectionViewSize)/2, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if(self.arrTitle[indexPath.row] == "General"){
            if APP_DELEGATE.userType == LoginType.Staff{
                if let viewController: StaffProfileViewController = StaffProfileViewController.storyboardInstance.initialize() {
                    viewController.objProfileData = self.objStaffProfileData
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }else{
                if let viewController: ProfileGeneralViewController = ProfileGeneralViewController.storyboardInstance.initialize() {
                    viewController.objGeneralProfileData = self.objProfileData
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            
        }
        if(self.arrTitle[indexPath.row] == "Health"){
            if let viewController: MedicalViewController = MedicalViewController.storyboardInstance.initialize() {
                viewController.objGeneralProfileData = self.objProfileData
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        if(self.arrTitle[indexPath.row] == "Parent"){
            if let viewController: ParentViewController = ParentViewController.storyboardInstance.initialize() {
                viewController.objGeneralProfileData = self.objProfileData
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        if(self.arrTitle[indexPath.row] == "Sibling"){
            if let viewController: ChildListViewController = ChildListViewController.storyboardInstance.initialize() {
                viewController.isFromProfile = true
                viewController.imgPath = self.imgURL
                viewController.objGeneralProfileData = self.objProfileData
            self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        if(self.arrTitle[indexPath.row] == "Transport"){
            if let viewController: ProfileTransportViewController = ProfileTransportViewController.storyboardInstance.initialize() {
                
               viewController.objGeneralProfileData = self.objProfileData
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        if(self.arrTitle[indexPath.row] == "Department"){
            if let viewController: ProfileDepartmentViewController = ProfileDepartmentViewController.storyboardInstance.initialize() {
                viewController.objProfileData = self.objStaffProfileData
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        if(self.arrTitle[indexPath.row] == "Qualification"){
            if let viewController: ProfileQualificationViewController = ProfileQualificationViewController.storyboardInstance.initialize() {
                viewController.objProfileData = self.objStaffProfileData
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
         /*
        if(self.arrTitle[indexPath.row] == "Transport"){
            if let viewController: ProfileTransportViewController = ProfileTransportViewController.storyboardInstance.initialize() {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
         */
    }
}
extension ProfileViewController {
    func callAPIStudentDetails(finished:@escaping(_ success: Bool, _ response: StudentDetailAPIResponse?) -> Void) {
        Loader.show()
        
//        var arrStudents = [LoginAPIStudent]()
//        arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        
        StudentManagementAPI.getStuddentDetails(studentID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "") { (response, error) in
            Loader.hide()
            guard let response = response else {
                let _ = error?.localizedDescription ?? "Invalid Response"
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let _ = response.message else {
                let _ = response.message ?? "Invalid Response"
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    
    func callAPIStaffDetails(finished:@escaping(_ success: Bool, _ response: StaffDetailAPIResponse?) -> Void) {
        Loader.show()
        
        StaffManageMentAPI.getStaffDetails() { (response, error) in
            Loader.hide()
            guard let response = response else {
                let _ = error?.localizedDescription ?? "Invalid Response"
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let _ = response.message else {
                let _ = response.message ?? "Invalid Response"
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
}
