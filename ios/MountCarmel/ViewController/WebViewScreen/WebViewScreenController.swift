//
//  WebViewScreenController.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 25/01/25.
//  Copyright © 2025 Mount Carmel School. All rights reserved.
//

import UIKit
import WebKit

class WebViewScreenController: UIViewController {

    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var webView: WKWebView!
    
    var urlToOpen : URL?
    var navbarTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = navbarTitle
        navigationView.delegate = self
        
        self.loadWebView()
    }
    
    func loadWebView(){
        Loader.show()
        guard let url = urlToOpen else {
            toast("URL in invalid - \(String(describing: urlToOpen?.absoluteString))")
            Loader.hide()
            return
        }
        webView.backgroundColor = UIColor.white
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
}

extension WebViewScreenController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.hide()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.hide()
        self.toast(error.localizedDescription)
    }
}

extension WebViewScreenController: NavigationBarViewDelegate {
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
