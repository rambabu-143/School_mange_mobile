//
//  HostViewController.swift
//  MountCarmel
//
//  Created by Apple on 01/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import AKSideMenu


class HostViewController: AKSideMenu, AKSideMenuDelegate {
    override func viewDidAppear(_ animated: Bool) {
        let isBioEnabled = BiometricAuthManager.shared.isBiometricServiceEnabled()
        
        // If BioMetric enabled and not authenticated
        if isBioEnabled {
            mayPresentFaceIDModal()
        } else if APP_DELEGATE.enableFaceIDPromptNeeded {
            mayPresentFaceIDEnableModal()
        }
    }
    
    private func mayPresentFaceIDModal() {
        let isBioAuthenticated = APP_DELEGATE.isBiometricAuthenticated
        
        if !isBioAuthenticated, let faceIDViewController: FaceIDViewController = FaceIDViewController.storyboardInstance.initialize() {
            faceIDViewController.modalPresentationStyle = .overFullScreen
            faceIDViewController.modalTransitionStyle = .crossDissolve
            
            present(faceIDViewController, animated: true, completion: nil)
        }
    }
    
    private func mayPresentFaceIDEnableModal() {
        let (canUseBio, error) = BiometricAuthManager.shared.canUseBiometricService()
        if canUseBio {
            let faceIDEnableViewController = FaceIDEnableViewController()
            faceIDEnableViewController.modalPresentationStyle = .overFullScreen
            faceIDEnableViewController.modalTransitionStyle = .crossDissolve
            
            present(faceIDEnableViewController, animated: true, completion: nil)
        } else if let error = error {
            print("Can't use Biometric Authentication \n Error: \(error.localizedDescription)")
        } else {
            print("Biometric service is not available, and no error was provided.")
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.menuPreferredStatusBarStyle = .lightContent
        self.contentViewShadowColor = .black
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.5
        self.contentViewShadowRadius = 8
        self.contentViewShadowEnabled = true
        self.contentViewScaleValue = 0.8
        //self.backgroundImage = UIImage(named: "Stars")
        self.delegate = self

            let storyboard = UIStoryboard.init(name: "SideMenu", bundle: nil)
            self.contentViewController = storyboard.instantiateViewController(withIdentifier: "contentViewController")
            self.leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenu")
    }
    

    // MARK: - <AKSideMenuDelegate>

    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("willShowMenuViewController")
    }

    public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }

    public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
        if let homevc = ((UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? HostViewController)?.children.last as? UINavigationController)?.viewControllers.last as? HomeViewController{
            homevc.layoutCollectionViewCell()
        }
    }

    public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
       
    }
}

