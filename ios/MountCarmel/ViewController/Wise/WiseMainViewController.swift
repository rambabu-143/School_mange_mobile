//
//  WiseMainViewController.swift
//  MountCarmel
//
//  Created by Sandip on 06/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class WiseMainViewController: UIViewController {

    @IBOutlet var containerViewStudent: UIView!
    @IBOutlet var containerViewClass: UIView!
    @IBOutlet var scrlView: UIScrollView!
    @IBOutlet var btnStudent: UIButton!
    @IBOutlet var btnClass: UIButton!
    @IBOutlet weak var navigationView: NavigationBarView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "WISE"
        navigationView.delegate = self
        setUpView()
        btnStudent.backgroundColor = UIColor.white
        btnStudent.titleLabel?.textColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
        
        btnStudent.titleLabel?.font = UIFont.setBoldFont(ofSize: 13.0)
        btnClass.titleLabel?.font = UIFont.setBoldFont(ofSize: 13.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(_:)), name: NSNotification.Name(rawValue: "UpdateSegmentColor"), object: nil)
    }
    func setUpView(){
        // set Frame for All ScrollVIew contents
        containerViewClass.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: containerViewClass.frame.size.height)
        var width = self.view.frame.size.width
        
        containerViewStudent.frame = CGRect(x: width, y: 0, width: self.view.frame.size.width, height: containerViewStudent.frame.size.height)
        width = containerViewStudent.frame.size.width + containerViewStudent.frame.origin.x
        
        scrlView.contentSize = CGSize(width: width, height: scrlView.contentSize.height)
    }
    
    @objc func notificationReceived(_ notification: NSNotification) {
        btnStudent.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
        // btnStudent.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnStudent.setTitleColor(UIColor.white, for: .normal)
        
        btnClass.backgroundColor = UIColor.white
        btnClass.titleLabel?.textColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
    }
    
    //MARK:- Action Event -
    
    @IBAction func btnStudentClick(_ sender: Any) {
        scrlView.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
        
        btnStudent.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
       // btnStudent.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnStudent.setTitleColor(UIColor.white, for: .normal)
        
        btnClass.backgroundColor = UIColor.white
        btnClass.titleLabel?.textColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
       
    }
    
    @IBAction func btnClassClick(_ sender: Any) {
         scrlView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        btnClass.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
        btnClass.titleLabel?.textColor = UIColor.white
        
        btnStudent.backgroundColor = UIColor.white
        btnStudent.titleLabel?.textColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)

    }
}

extension WiseMainViewController: NavigationBarViewDelegate {
    
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
