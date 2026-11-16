//
//  SelectProfileTypeViewController.swift
//  MountCarmel
//
//  Created by Sandip on 07/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SelectProfileTypeViewController: UIViewController {
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblMobileNumber: UILabel!
    @IBOutlet var lblCode: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var tblChildList: UITableView!
    var data : LoginAPIStudent?
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    func setInitialView(){
        tblChildList.register(UINib(nibName: "ChildListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChildListTableViewCell")
        
        let userInfo = APP_DELEGATE.userInfo
        let urlPath = (APP_DELEGATE.loginAPIResponse?.path ?? "") + "/"
        let imageURL = urlPath + (userInfo?.staffId?.profile_pic ?? "")
        self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        self.lblName.text = userInfo?.name
        self.lblMobileNumber.text = userInfo?.mobile
        self.lblCode.text = APP_DELEGATE.loginAPIResponse?.metaData?.schoolCode
        
        self.lblName.font = UIFont.setBoldFont(ofSize: 15)
        self.lblCode.font = UIFont.setRegularFont(ofSize: 13)
        self.lblMobileNumber.font = UIFont.setRegularFont(ofSize: 14)
        
        
    }
    
    @IBAction func actionGotoStaff(_ sender: Any) {
        APP_DELEGATE.isLoggedIn = true
        APP_DELEGATE.manageApplicationRoot()
    }
    
}

extension SelectProfileTypeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APP_DELEGATE.userInfo?.students?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblChildList.dequeueReusableCell(withIdentifier: "ChildListTableViewCell", for: indexPath) as? ChildListTableViewCell
        let studentData = APP_DELEGATE.userInfo?.students?[indexPath.row]
        
        cell?.lblName.text = studentData?.studentId?.name ?? ""
        cell?.lblID.text = studentData?.studentId?.admissionNo ?? ""
        let strClass = (studentData?.studentId?.standardId?.name ?? "") + " "
        
        cell?.btnClass.setTitle("class: \(strClass + (studentData?.studentId?.sectionId?.name ?? ""))", for: .normal)
        //studentImageIssue
        cell?.imgProfile.sd_setImage(with: URL(string: studentData?.studentId?.studentImg ?? ""), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        APP_DELEGATE.isLoggedIn = true
        
        if juniorBranchCodes.contains(APP_DELEGATE.userInfo?.students?[indexPath.row].studentId?.year_branch ?? 0){
            APP_DELEGATE.userType = LoginType.Nursery
        }else{
            APP_DELEGATE.userType = LoginType.School
        }
        
      /*  if APP_DELEGATE.userInfo?.students?[indexPath.row].studentId?.school_type?.uppercased() == "JUNIOR"{
             APP_DELEGATE.userType = LoginType.Nursery
        }else{
             APP_DELEGATE.userType = LoginType.School
        }*/
        
       // APP_DELEGATE.selected_Student = APP_DELEGATE.userInfo?.students?[indexPath.row]
        //APP_DELEGATE.manageApplicationRoot()
        
        self.SwithStudent(index: indexPath.row)
    }
    
    private func SwithStudent(index:Int){
        let selectedAddmisionNo =  APP_DELEGATE.userInfo?.students?[index].studentId?.admissionNo ?? ""
        let email = APP_DELEGATE.userInfo?.students?[index].studentId?.email ?? ""
        print(selectedAddmisionNo)
        
        guard selectedAddmisionNo != (APP_DELEGATE.selected_Student?.admissionNo ?? "") else {
            self.toast("Already selected")
            return
        }
        
        Loader.show()
        let request = switchStudent(email: email, admission_no:selectedAddmisionNo)
        
        StaffManageMentAPI.switchStudent(body: request) { (response, error) in
            Loader.hide()
            if response?.status == true {
              /*  guard
                    let tokenData = response?.user?.tokens?.first(where: { (tokenData) -> Bool in tokenData.platform?.lowercased() == PLATFORM_TYPE }), let tokenID = tokenData.ID, let token = tokenData.token, token.isEmpty == false,
                    let userID = response?.user?.ID, userID.isEmpty == false else {
                    self.toast("API Authentication credentials not received yet");
                    return;
                }
                APP_DELEGATE.tokenID = tokenID
                */
                guard let userID = response?.user?.ID, let token = response?.metaData?.token  else {
                    self.alert("Token is empty") { action in }
                      return
                  }
                
                APP_DELEGATE.loginAPIResponse = response
                APP_DELEGATE.token = token
                APP_DELEGATE.urlPath = response?.path ?? ""
                APP_DELEGATE.strurlPath = response?.path ?? ""
                APP_DELEGATE.yearSession = response?.metaData?.yearSession ?? ""
                
                APP_DELEGATE.userID = userID
                
                APP_DELEGATE.userInfo = response?.user
                
                APP_DELEGATE.userType = LoginType.Parent
                
                
                if let students = response?.user?.students{
                  for student in students{
                      if student.admissionNo == selectedAddmisionNo{
                          APP_DELEGATE.selected_Student = student
                      }
                  }
                }
                APP_DELEGATE.isLoggedIn = true
                DispatchQueue.main.async { self.dismiss(animated: false) }
                  
                APP_DELEGATE.manageApplicationRoot()
                
            } else {
                self.toast(response?.message ?? "")
            }
        }
    }
}
