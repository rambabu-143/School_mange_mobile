//
//  FaceIDEnableViewController.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 10/06/24.
//  Copyright © 2024 InventionHill. All rights reserved.
//
import UIKit
import LocalAuthentication

class FaceIDEnableViewController: UIViewController {
    private let maxTries = 3
    private var tried = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let biometricTypeLabel = BiometricAuthManager.shared.biometricTypeLabel
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Enable \(biometricTypeLabel) ID for Secure Access"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let messageLabel = UILabel()
        messageLabel.text = "Enable \(biometricTypeLabel) ID for quick and secure access to your account without logging out.\n\nYou can enable or disable it anytime from settings."
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        
        let enableButton = UIButton(type: .system)
        enableButton.setTitle("Enable \(biometricTypeLabel) ID", for: .normal)
        enableButton.addTarget(self, action: #selector(enableButtonTapped), for: .touchUpInside)
        enableButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(enableButton)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Not Now", for: .normal)
        cancelButton.setTitleColor(.gray, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cancelButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            enableButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            enableButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            cancelButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func enableButtonTapped() {
        // modal dismiss is handled inside `onEnablePress` function
        onEnablePress()
    }
    
    @objc private func cancelButtonTapped() {
        APP_DELEGATE.enableFaceIDPromptNeeded = false
        dismiss(animated: false, completion: nil)
    }
    
    private func onEnablePress() {
        let (canUseBio, error) = BiometricAuthManager.shared.canUseBiometricService()
        if canUseBio {
            let biometricTypeLabel = BiometricAuthManager.shared.biometricTypeLabel
            BiometricAuthManager.shared.authenticateUser{ success, error in
                DispatchQueue.main.async { [weak self] in
                    if success {
                        BiometricAuthManager.shared.setBiometricService(enabled: true)
                        APP_DELEGATE.enableFaceIDPromptNeeded = false
                        APP_DELEGATE.isBiometricAuthenticated = true
                        // Below line dismisses FaceIDEnableViewController modal
                        self?.dismiss(animated: false, completion: nil)
                    } else {
                        let error = error as? LAError
                        let alert = UIAlertController(
                            title: "Authentication Failed",
                            message: error?.localizedDescription ?? "\(biometricTypeLabel) ID authentication was unsuccessful. Please try again.",
                            preferredStyle: .alert
                        )
                        if let _self = self, _self.tried < _self.maxTries {
                            alert.addAction(UIAlertAction(title: "Try \(biometricTypeLabel) ID Again", style: .default, handler: { [weak self] _ in
                                self?.tried += 1
                                self?.onEnablePress()
                            }))
                        }
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] _ in
                            // Below line dismisses FaceIDEnableViewController modal after user presses "Cancel" button
                            self?.dismiss(animated: false, completion: nil)
                        }))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let biometricTypeLabel = BiometricAuthManager.shared.biometricTypeLabel
            let alert = UIAlertController(
                title: "\(biometricTypeLabel) ID Unavailable",
                message: error?.localizedDescription ?? "\(biometricTypeLabel) ID authentication is currently unavailable. Please try again later.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                // Below line dismisses FaceIDEnableViewController modal after user presses "OK" button
                self?.dismiss(animated: false, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
