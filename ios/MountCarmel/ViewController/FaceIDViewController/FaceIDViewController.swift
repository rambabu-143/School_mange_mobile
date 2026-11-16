//
//  FaceIDViewController.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 07/06/24.
//  Copyright © 2024 InventionHill. All rights reserved.
//

import UIKit
import LocalAuthentication

class FaceIDViewController: UIViewController {
    @IBOutlet weak var userNameLabelView: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var actionsContainerView: UIStackView!
    @IBOutlet weak var biometricAuthButtonView: UIButton!
    @IBOutlet weak var logoutButtonView: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlurEffect()

        let userInfo = APP_DELEGATE.userInfo
        
        if let username = userInfo?.name?.capitalized {
            userNameLabelView.text = "\(username) (\(APP_DELEGATE.userType))"
        } else {
            userNameLabelView.text = ""
        }
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .extraLight) // Choose the desired blur style
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        // Ensure the blur effect view covers the entire view
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add the blur effect view to the view hierarchy
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authenticateUser()
    }

    @IBAction func onBiometricAuthPress(_ sender: UIButton) {
        authenticateUser()
    }

    @IBAction func onLogoutPress(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
         logoutUser()
    }
    
    private func onAuthenticationStarted() {
        actionsContainerView.isHidden = true
        logoView.alpha = 0.7
    }
    
    private func onAuthenticationFailed() {
        actionsContainerView.isHidden = false
        logoView.alpha = 1
    }
    
    private func onAuthenticationSuccess() {
        APP_DELEGATE.isBiometricAuthenticated = true
        APP_DELEGATE.manageApplicationRoot()
    }

    private func logoutUser() {
        APP_DELEGATE.RemoveAllDefaults()
    }

    private func authenticateUser() {
        onAuthenticationStarted()
        let (canUse, error) = BiometricAuthManager.shared.canUseBiometricService()
        guard canUse else {
            let biometricTypeLabel = BiometricAuthManager.shared.biometricTypeLabel
            let alert = UIAlertController(
                title: "\(biometricTypeLabel) ID Unavailable",
                message: error?.localizedDescription ?? "\(biometricTypeLabel) ID authentication is currently unavailable" + ". Please try again later or logout.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {[weak self] _ in self?.onAuthenticationFailed()}))
            alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {[weak self] _ in self?.logoutUser()}))
            present(alert, animated: true, completion: nil)
            return
        }
        let biometricTypeLabel = BiometricAuthManager.shared.biometricTypeLabel
        BiometricAuthManager.shared.authenticateUser { success, error in
            DispatchQueue.main.async { [weak self] in
                if let self = self {
                    if success {
                        self.onAuthenticationSuccess()
                    } else {
                        let error = error as? LAError
                        let alert = UIAlertController(
                            title: "Authentication Failed",
                            message: error?.localizedDescription ?? "\(biometricTypeLabel) ID authentication was unsuccessful. Please try again.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "Try \(biometricTypeLabel) ID again", style: .default, handler: { _ in
                            self.authenticateUser()
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                            self.onAuthenticationFailed()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
