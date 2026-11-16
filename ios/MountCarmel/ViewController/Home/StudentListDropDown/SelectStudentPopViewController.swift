//
//  SelectStudentPopViewController.swift
//  MountCarmel
//
//  Created by Sandip on 30/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import SDWebImage

class SelectStudentPopViewController: UIViewController {
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var tblHeightConstraint: NSLayoutConstraint!
    var doneHandler : ((Int) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
       /* DispatchQueue.main.async {
            self.tblView.layoutIfNeeded()
            self.tblHeightConstraint.constant = self.tblView.contentSize.height + 10
            self.tblView.layoutIfNeeded()
            self.tblView.isScrollEnabled = false
            
            if(self.tblHeightConstraint.constant > 300){
               // self.tblHeightConstraint.constant = 300
                self.tblView.isScrollEnabled = true
            }
        }*/
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tblView.layoutIfNeeded()
            if let students = APP_DELEGATE.userInfo?.students{
                self.tblHeightConstraint.constant = CGFloat(students.count) * 85.0
            }
            self.tblView.layoutIfNeeded()
        }
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBackViewClick(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func actionClosePopUp(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectStudentPopViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* if APP_DELEGATE.userInfo?.type?.uppercased() == "STAFF" {
            return  1 + (APP_DELEGATE.userInfo?.students?.count ?? 0)
        }else{
            return APP_DELEGATE.userInfo?.students?.count ?? 0
        }*/
        return APP_DELEGATE.userInfo?.students?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "StudentListCell", for: indexPath) as? StudentListCell
        
      /*  if APP_DELEGATE.userInfo?.type?.uppercased() == "STAFF"{
            if(indexPath.row == 0){
                let userInfo = APP_DELEGATE.userInfo
                let urlPath = APP_DELEGATE.urlPath + "/"
                let imageURL = urlPath + (userInfo?.staffId?.profile_pic ?? "")
                cell?.lblStudentName.text = userInfo?.name ?? ""
                cell?.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
                
            }else{
                let student = APP_DELEGATE.userInfo?.students?[indexPath.row - 1]
                cell?.lblStudentName.text = student?.studentId?.name ?? ""
                
                cell?.imgProfile.sd_setImage(with: URL(string: student?.studentId?.studentImg ?? ""), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
            }
        }else{
            let student = APP_DELEGATE.userInfo?.students?[indexPath.row]
            cell?.lblStudentName.text = student?.studentId?.name ?? ""
            
            cell?.imgProfile.sd_setImage(with: URL(string: student?.studentId?.studentImg ?? ""), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
        }*/
        
        let student = APP_DELEGATE.userInfo?.students?[indexPath.row]
        cell?.lblStudentName.text = student?.studentId?.name ?? ""
        //studentImageIssue
        let path = (APP_DELEGATE.loginAPIResponse?.path ?? "")+(student?.studentId?.profile_pic ?? "")
        cell?.imgProfile.sd_setImage(with: URL(string: path/*student?.studentId?.studentImg ?? ""*/), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //guard indexPath.row != 0 else {return}
    
        self.SwithStudent(index: indexPath.row)
        
      /*  DispatchQueue.main.async {
            self.dismiss(animated: false) {
                if(self.doneHandler != nil){
                    self.doneHandler!(indexPath.row)
                }
            }
        }*/
        
    }
    
    private func SwithStudent(index:Int){
        let selectedAddmisionNo =  APP_DELEGATE.userInfo?.students?[index].studentId?.admissionNo ?? ""
        let email = APP_DELEGATE.userInfo?.students?[index].studentId?.email ?? ""
        print(selectedAddmisionNo)
        
        guard selectedAddmisionNo != (APP_DELEGATE.selected_Student?.admissionNo ?? "") else {
            self.toast("Already selected")
            return
        }
        
        let request = switchStudent(email: email, admission_no:selectedAddmisionNo)
        
        StaffManageMentAPI.switchStudent(body: request) { (response, error) in
            Loader.hide()
            UserDefaults.standard.removeObject(forKey: "StoryChecked")
            if response?.status == true {
              /*  guard
                    let tokenData = response?.user?.tokens?.first(where: { (tokenData) -> Bool in tokenData.platform?.lowercased() == PLATFORM_TYPE }), let tokenID = tokenData.ID, let token = tokenData.token, token.isEmpty == false,
                    let userID = response?.user?.ID, userID.isEmpty == false else {
                    self.toast("API Authentication credentials not received yet");
                    return;
                }
                APP_DELEGATE.tokenID = tokenID
                */
                guard
                      let userID = response?.user?.ID, let token = response?.metaData?.token  else {
                    self.alert("Token is empty") { action in }
                      return;
                  }
                APP_DELEGATE.loginAPIResponse = response
                print("Bearer "+(response?.metaData?.token ?? ""))
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
                
              /*  if(response?.user?.type?.uppercased() == "FATHER" || response?.user?.type?.uppercased() == "MOTHER" || response?.user?.type?.uppercased() == "PARENT"){
                    APP_DELEGATE.selected_Student = response?.user?.students?[0]
                    APP_DELEGATE.userType = LoginType.Parent
                    APP_DELEGATE.parent_URL = response?.parent_path ?? ""
                    APP_DELEGATE.isLoggedIn = true
                    APP_DELEGATE.manageApplicationRoot()
                }else if(response?.user?.type?.uppercased() == "STUDENT"){
                    APP_DELEGATE.selected_Student = response?.user?.students?[0]
                    
                    if juniorBranchCodes.contains(response?.user?.students?[0].studentId?.year_branch ?? 0){
                        APP_DELEGATE.userType = LoginType.Nursery
                    }else{
                        APP_DELEGATE.userType = LoginType.School
                    }
                    
                   /* if(response?.user?.students?[0].studentId?.school_type?.uppercased() == "JUNIOR"){
                        APP_DELEGATE.userType = LoginType.Nursery
                    }else{
                        APP_DELEGATE.userType = LoginType.School
                    }*/
                    APP_DELEGATE.isLoggedIn = true
                    APP_DELEGATE.manageApplicationRoot()
                    
                }else{
                    APP_DELEGATE.userType = LoginType.init(rawValue: response?.user?.type ?? "STAFF") ?? LoginType.Staff
                    if let vc: SelectProfileTypeViewController = SelectProfileTypeViewController.storyboardInstance.initialize() {
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }*/
                
                
            } else {
                self.toast(response?.message ?? "")
            }
        }
    }
}
