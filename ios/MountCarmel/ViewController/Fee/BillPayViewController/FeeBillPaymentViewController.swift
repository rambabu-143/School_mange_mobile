//
//  FeeBillPaymentViewController.swift
//  MountCarmel
//
//  Created by Sandip on 01/09/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import WebKit

class FeeBillPaymentViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var webView: WKWebView!
    
    var feesUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.delegate = self
        if feesUrl == API_PAYSCHOOLBILL{
            navigationView.lblTitle.text = "School Fee"
        }else if feesUrl == API_PAYTRANSPORTBILL{
            navigationView.lblTitle.text = "Transport Fee"
        }else{
            navigationView.lblTitle.text = "Hostel Fee"
        }
            
        var URLString = ""
        if APP_DELEGATE.userType == .Staff{
            let staffID = APP_DELEGATE.userInfo?.staffId?.ID ?? ""
             URLString = feesUrl.replacingOccurrences(of:API_KEY_STAFF_ID, with: staffID)
        }else{
            let studentID = APP_DELEGATE.selected_Student?.studentId?.ID ?? ""
            URLString = feesUrl.replacingOccurrences(of:API_KEY_STUDENT_ID, with: studentID)
        }
        
        
        Loader.show()
        let url = URL(string: URLString)!
        webView.backgroundColor = UIColor.white
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        
    }
    
    private func GoBackAfterPayment(msg:String){
        self.toast(msg)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension FeeBillPaymentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.hide()
        print(webView.url)
            guard let currentUrl = webView.url?.absoluteString else {return}
             print(currentUrl)
            
          /* if currentUrl.contains("/onSuccessfullFeePayment"){
                self.GoBackAfterPayment()
            }else if currentUrl.contains("/onSuccessfullTransportPayment"){
                self.GoBackAfterPayment()
            }else if currentUrl.contains("/onSuccessfullStaffTransportPayment"){
                self.GoBackAfterPayment()
            }else*/
        
            if currentUrl.contains("dashboard"){
               self.GoBackAfterPayment(msg: "Your payment was successful")
                
            }else if currentUrl.contains("fee-bill") && currentUrl.contains("login"){
                self.GoBackAfterPayment(msg: "Oops! The payment has been declined by the bank.")
                
            }else if currentUrl.contains("transport-bill") && currentUrl.contains("login"){
                self.GoBackAfterPayment(msg: "Oops! The payment has been declined by the bank.")
                
            }else if currentUrl.contains("staff-transport-bill") && currentUrl.contains("login"){
                self.GoBackAfterPayment(msg: "Oops! The payment has been declined by the bank.")
                
            }else{
                print("Payment not done")
            }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        }else{
             completionHandler(.useCredential, nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.hide()
    }
    
}

extension FeeBillPaymentViewController: NavigationBarViewDelegate {
    func onTapDropDown() {
        
    }
    func onTapMenu() {
        
    }
    
    func onTapBack() {
        let alertViewController = UIAlertController(title: "Do you want to exit?", message: "", preferredStyle: .alert)
        let alertYes = UIAlertAction(title: "YES", style: .default) { _ in
            if self.navigationController?.viewControllers.count ?? 0 == 1 {
                self.setHomeScreen()
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let alertNo = UIAlertAction(title: "NO", style: .default) { _ in }
        
        alertViewController.addAction(alertNo)
        alertViewController.addAction(alertYes)
        
        self.present(alertViewController, animated: true, completion: nil)
        
     
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

/* webView.evaluateJavaScript("document.getElementById(\"my-id\").innerHTML", completionHandler: { (jsonRaw: Any?, error: Error?) in
     guard let jsonString = jsonRaw as? String else { return }
     let json = JSON(parseJSON: jsonString)
     // do stuff
 })
*/
