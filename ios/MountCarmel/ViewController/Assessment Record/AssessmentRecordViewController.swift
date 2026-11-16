//
//  AssessmentRecordViewController.swift
//  MountCarmel
//
//  Created by Niraj on 07/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import WebKit

class AssessmentRecordViewController: UIViewController {

    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var btnDownload: UIButton!{didSet{btnDownload.isHidden=true}}
    
    var objDataSheet : AssesmentData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Assessment Record"
        navigationView.delegate = self
        self.callGetAssesmentRecord { (success) in
            if(success){
                self.loadWebView()
            }
        }
        //http://www.africau.edu/images/default/sample.pdf
    }
    
    func loadWebView(){
        Loader.show()
        if let strUrl = objDataSheet?.assessment_record, let url = URL(string: strUrl){
            webView.backgroundColor = UIColor.white
            webView.navigationDelegate = self
            webView.load(URLRequest(url: url ))
        }else{
             Loader.hide()
        }
    }
    @IBAction func btndownload(_ sender: Any) {
        CommonFunctions.download_and_save_file(str_url: self.objDataSheet?.assessment_record ?? "") { msg in
            DispatchQueue.main.async {
                self.toast(msg)
            }
        }
    }
}

extension AssessmentRecordViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.hide()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.hide()
    }
}

extension AssessmentRecordViewController: NavigationBarViewDelegate {
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
extension AssessmentRecordViewController{
    func callGetAssesmentRecord(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        ParentManagementAPI.getAssesmentRecord { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false)
                return
            }
            
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            
            if (response.message?.lowercased() ?? "").contains("not available") {
                self.toast(response.message ?? "Assesment Record not available")
                return
            }
            
            self.objDataSheet = responseData
           
            
            finished(true)
        }
    }
    
}
