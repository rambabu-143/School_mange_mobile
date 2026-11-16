//
//  ImagePreviewViewController.swift
//  MountCarmel
//
//  Created by Sandip on 10/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import SDWebImage

class ImagePreviewViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!

    @IBOutlet var imgPreview: UIImageView!
    var strImgURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.isHidden = true
        navigationView.btnMenu.isHidden = true
        navigationView.btnAppLogo.isHidden = true
        navigationView.btnbadgeCount.isHidden = true
        navigationView.btnNotification.isHidden = true
        navigationView.delegate = self
        
        imgPreview.sd_setImage(with: URL(string: strImgURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        // Do any additional setup after loading the view.
    }
}
extension ImagePreviewViewController: NavigationBarViewDelegate {
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
