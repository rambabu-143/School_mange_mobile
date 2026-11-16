//
//  LoginViewController.swift
//  MountCarmel
//
//  Created by Niraj on 29/02/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import GoogleSignIn
class LoginViewController: UIViewController {
    
    @IBOutlet var txtMobileNumber: RoundTextField! // For Parent Login
    
    @IBOutlet weak var roundedViewStudentAndStaff: RoundedView!
    @IBOutlet weak var roundedViewParent: RoundedView!
    //@IBOutlet var btnLogin: RoundedButton!
    //@IBOutlet weak var txtMobile: RoundTextField!
    //@IBOutlet weak var txtPassword: RoundTextField!
    // stepNew - 1 Start
    @IBOutlet weak var viewSignGoogle: UIView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!{
        didSet{
            indicator.stopAnimating()
        }
    }
    
    //@IBOutlet weak var btnLoginBottomConst: NSLayoutConstraint!
    //// stepNew - 1 End
    var isParentSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        txtMobileNumber.delegate = self
        self.txtMobile.font = UIFont.setRegularFont(ofSize: 15.0)
        self.txtMobileNumber.font = UIFont.setRegularFont(ofSize: 15.0)
        self.txtPassword.font = UIFont.setRegularFont(ofSize: 15.0)
        self.btnLogin.titleLabel?.font = UIFont.setBoldFont(ofSize: 16.0)
        
        self.txtMobileNumber.isHidden = true
        self.txtMobile.isHidden = false
        self.txtPassword.isHidden = false
        // ---- For Parent Login Hide Email and Password Fields
        if isParentSelected {
            self.txtMobileNumber.isHidden = false
            self.txtMobile.isHidden = true
            self.txtPassword.isHidden = true
            // stepNew - 2 Start
            btnLoginBottomConst.constant = 40.0
            viewSignGoogle.isHidden = true
        }else{
            btnLoginBottomConst.constant = 120.0
            viewSignGoogle.isHidden = false
        }*/
        
        txtMobileNumber.delegate = self
        self.txtMobileNumber.font = UIFont.setRegularFont(ofSize: 15.0)
        
        
        
        if isParentSelected {
            roundedViewParent.isHidden = false
            roundedViewStudentAndStaff.isHidden = true
        }else{
            roundedViewParent.isHidden = true
            roundedViewStudentAndStaff.isHidden = false
        }
        
        
        //// stepNew - 2 End
        
        //Staff
        
//                self.txtMobile.text = "poojaarora@mountcarmelschool.com"
//                self.txtPassword.text = "bhoopendra"
        //--------Staff Login ------ //
//                self.txtMobile.text = "webmaster@mountcarmelschool.com"
//                self.txtPassword.text = "bhoopendra"
//
        //------ Nursery to 3rd ------//
        //Live Login
        
//                self.txtMobile.text = "umairahkadam1901@mountcarmelschool.com"
//                self.txtPassword.text = "father"
        
        //test Login //
//            self.txtMobile.text = "mananbhatia0305@mountcarmeldelhi.com"
//            self.txtPassword.text = "father"
        
        //        // -------- 4th to 12th ----- //
//                self.txtMobile.text = "aaravarora3010@mountcarmeldelhi.com"
//                self.txtPassword.text = "father"
        
//        // parent
//        self.txtMobile.text = "JITENDRA_PANDE@HOTMAIL.COM"
//        self.txtPassword.text = "father"
//
        // Do any additional setup after loading the view.

      
    }
    
    @IBAction func btnTapLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if isParentSelected{
            
            if txtMobileNumber.text!.isEmpty {
                self.toast("Enter Mobile Number")
                
            } else if txtMobileNumber.text!.count != 10 {
                self.toast("Enter Valid Mobile Number")
            }
            else{
                let alertController = UIAlertController.init(title: "", message: "Are you sure this number " +  (self.txtMobileNumber.text ?? "") + " is registered with Mount Carmel as Parent?", preferredStyle: .alert)
                
                let btnCancel = UIAlertAction.init(title:"Edit" , style: .cancel) { (action) in
                    
                }
                alertController.addAction(btnCancel)
                
                let btnTakePhoto = UIAlertAction.init(title: "Continue" , style: .default) { (action) in
                   // Loader.show()
                    self.indicator.startAnimating()
                    let request = LoginOTPRequest(mobileno: self.txtMobileNumber.text ?? "")
                    
                    UserManagementAPI.generateOTP(body: request) { (response, error) in
                     //   Loader.hide()
                        self.indicator.stopAnimating()
                        if response?.status == true {
                            if let vc: OtpViewController = OtpViewController.storyboardInstance.initialize() {
                                vc.modalPresentationStyle = .fullScreen
                                vc.strMobileNo = self.txtMobileNumber.text ?? ""
                                self.present(vc, animated: true, completion: nil)
                            }
                        }else{
                            self.toast(response?.message ?? "")
                        }
                    }
                                        
                }
                alertController.addAction(btnTakePhoto)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }/*else{
            if sender.tag == 1 {
                //Staff
                if self.txtMobile.text?.isEmpty == true {
                    //self.toast("Please enter mobile number")
                    self.toast("Please enter email address")
                }
                else if self.txtMobile.text?.isValidEmail() == false {
                    self.toast("Please enter email valid address")
                }
                else if self.txtPassword.text?.isEmpty == true {
                    self.toast("Please enter password")
                } else {
                    Loader.show()
                    let strEmail = self.txtMobile.text
                    let strPassword = self.txtPassword.text
                    let request = LoginUserRequest(email: strEmail, password: strPassword)
                    UserManagementAPI.login(body: request) { (response, error) in
                        Loader.hide()
                        if response?.status == true {
                            guard
                                let tokenData = response?.user?.tokens?.first(where: { (tokenData) -> Bool in tokenData.platform?.lowercased() == PLATFORM_TYPE }), let tokenID = tokenData.ID, let token = tokenData.token, token.isEmpty == false,
                                let userID = response?.user?.ID, userID.isEmpty == false else {
                                self.toast("API Authentication credentials not received yet");
                                return;
                            }
                            APP_DELEGATE.loginAPIResponse = response
                            print("Bearer "+(response?.metaData?.token ?? ""))
                            APP_DELEGATE.tokenID = tokenID
                            APP_DELEGATE.token = (response?.metaData?.token ?? "")
                            APP_DELEGATE.urlPath = response?.path ?? ""
                            APP_DELEGATE.strurlPath = response?.path ?? ""
                            APP_DELEGATE.yearSession = response?.metaData?.yearSession ?? ""
                            
                            APP_DELEGATE.userID = userID
                            
                            APP_DELEGATE.userInfo = response?.user
                            
                            
                            if(response?.user?.type?.uppercased() == "FATHER" || response?.user?.type?.uppercased() == "MOTHER" || response?.user?.type?.uppercased() == "PARENT"){
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
                            }
                            
                            
                        } else {
                            self.toast(response?.message ?? "")
                        }
                    }
                }
                return;
            }else if sender.tag == 2 {
                APP_DELEGATE.userType = LoginType.School
            }else if sender.tag == 3 {
                APP_DELEGATE.userType = LoginType.Parent
            }else if sender.tag == 4 {
                APP_DELEGATE.userType = LoginType.Nursery
            }
        }*/
    }
    
    
    @IBAction func btnGSignIn(_ sender: Any) {
        
        GIDSignIn.sharedInstance.signIn(with: GIDConfig.shared.instance, presenting: self) { user, error in
           // print(error)
            guard error == nil else {
                self.toast(error?.localizedDescription ?? "Gmail login error!")
                return
            }
            guard let strEmail = user?.profile?.email else{
                self.toast("No Gmail Address Found!!")
                return
            }
            user?.authentication.do { authentication, error in
                guard error == nil else {
                    self.toast(error?.localizedDescription ?? "User not authenticated!!")
                    return
                }
                guard let stridToken = authentication?.idToken else {
                self.toast(error?.localizedDescription ?? "Google idToken Error!!")
                return
            }
                   print(stridToken)
                self.SendGmailDataAndLoginUser(request: googleLoginUserRequest(email: strEmail, token: stridToken)) { hitagain in
                    if hitagain{
                        Loader.show()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                            Loader.hide()
                            self.SendGmailDataAndLoginUser(request: googleLoginUserRequest(email: strEmail, token: stridToken)) { hitagain in
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func SendGmailDataAndLoginUser(request:googleLoginUserRequest,completion:@escaping(Bool)->()){
        Loader.show()
        UserManagementAPI.googleLogin(body: request) { response, error in
            
                Loader.hide()
                if response?.status == true {
                 /*   guard
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
                    
                    APP_DELEGATE.token = token
                    UserDefaults.standard.set(token, forKey: "qwerty123")
                    print( "this is token ===========================",APP_DELEGATE.token)
                    APP_DELEGATE.urlPath = response?.path ?? ""
                    APP_DELEGATE.strurlPath = response?.path ?? ""
                    
                    APP_DELEGATE.yearSession = response?.metaData?.yearSession ?? ""
                    APP_DELEGATE.userID = userID
                    
                    APP_DELEGATE.userInfo = response?.user
                    
                    if(response?.user?.type?.uppercased() == "FATHER" || response?.user?.type?.uppercased() == "MOTHER" || response?.user?.type?.uppercased() == "PARENT"){
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
                     //   DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            guard APP_DELEGATE.token != "" else{
                                print("token is not in userdefaults")
                                completion(true)
                                return
                            }
                           print(token)
                            APP_DELEGATE.userType = LoginType.init(rawValue: response?.user?.type ?? "STAFF") ?? LoginType.Staff
                            if let vc: SelectProfileTypeViewController = SelectProfileTypeViewController.storyboardInstance.initialize() {
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                            }
                    //    }
                  
                    }
                    
                } else {
                    self.toast(response?.message ?? "")
                }
            }

    }
    
    @IBAction func btnDismissViewClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- API CAll
extension LoginViewController{
    
    func GenerateOTPForParentLogin(finished:@escaping(_ success: Bool) -> Void) {
        
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let charsLimit = 10
        
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        return newLength <= charsLimit
    }
}
