//
//  OtpViewController.swift
//  MountCarmel
//
//  Created by Sandip on 20/03/21.
//  Copyright © 2021 InventionHill. All rights reserved.
//

import UIKit
import SVPinView

class OtpViewController: UIViewController {

    @IBOutlet var otpView: SVPinView!
    @IBOutlet var btnResend: UIButton!
    @IBOutlet var lblnotReceiveOtp: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl1: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!{
        didSet{
            indicator.stopAnimating()
        }
    }
    var strOtpPin = ""
    var strMobileNo = ""
    
    var count = 60  // 60sec if you want
    var resendTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.font = UIFont.Regular(ofSize: 17)
        
        lbl1.font = UIFont.Regular(ofSize: 17)
        lbl2.font = UIFont.Regular(ofSize: 17)
        
        let str = "received on your mobile number"
        lbl2.text = str + " \(strMobileNo)"
        
        
        otpView.didChangeCallback = { pin in
            self.strOtpPin = pin
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func actionBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionVerifyClick(_ sender: Any) {
        
        if strOtpPin.isEmpty {
            self.toast("Please enter OTP")
        } else if strOtpPin.count != 6 {
            self.toast("Please enter correct OTP")
        } else {
            view.endEditing(true)
        }
        
        let request = verifyOTPRequest(mobileno: strMobileNo,otp: strOtpPin,platform: "ios")
        self.indicator.startAnimating()
        UserManagementAPI.verifyOTP(body: request) { (response, error) in
           // Loader.hide()
            self.indicator.stopAnimating()
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
                APP_DELEGATE.token = token
                APP_DELEGATE.urlPath = response?.path ?? ""
                APP_DELEGATE.strurlPath = response?.path ?? ""
                
                APP_DELEGATE.yearSession = response?.metaData?.yearSession ?? ""
                
                APP_DELEGATE.userID = userID
                APP_DELEGATE.userInfo = response?.user
                
                APP_DELEGATE.selected_Student = response?.user?.students?[0]
              
                APP_DELEGATE.userType = LoginType.Parent
                APP_DELEGATE.parent_URL = response?.parent_path ?? ""
                APP_DELEGATE.isLoggedIn = true
                APP_DELEGATE.manageApplicationRoot()
                
            }else{
                self.toast(response?.message ?? "")
            }
        }
    }
    
    @IBAction func actionResendOTPClick(_ sender: Any) {
        if btnResend.title(for: .normal) == "Resend"{
            let request = LoginOTPRequest(mobileno: strMobileNo)
            UserManagementAPI.generateOTP(body: request) { (response, error) in
                Loader.hide()
                if response?.status == true {
                    self.toast(response?.message ?? "")
                }else{
                    self.toast(response?.message ?? "")
                }
            }
            resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
       
    }

    @objc func update() {
        if(count > 0) {
            count = count - 1
            print(count)
            btnResend.setTitle("00:\(count)", for: .normal)
        }
        else {
            count = 60
            resendTimer.invalidate()
            btnResend.setTitle("Resend", for: .normal)
        }
    }
}
