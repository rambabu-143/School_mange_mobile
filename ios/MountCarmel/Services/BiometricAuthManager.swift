//
//  BiometricsService.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 01/06/24.
//  Copyright © 2024 InventionHill. All rights reserved.
//

import Foundation
import LocalAuthentication

class BiometricAuthManager {
    static let shared = BiometricAuthManager()

    private let biometricStateKey = "biometricStateKey"
    
    private var cachedBiometricType = LABiometryType.none
    
    var biometricType: LABiometryType {
        get {
            if cachedBiometricType != .none {
                return cachedBiometricType
            }
            let context = LAContext()
            let type = context.biometryType
            if type != .none {
                cachedBiometricType = type
            }
            return cachedBiometricType
        }
    }
    
    var biometricTypeLabel: String {
        get {
            return switch self.biometricType {
            case .faceID: "Face"
            case .touchID: "Touch"
            case .opticID: "Optic"
            case .none: "None"
            @unknown default:
                "None"
            }
        }
    }
    
    private init () {}
    
    func isBiometricServiceEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: biometricStateKey)
    }
    
    func setBiometricService(enabled: Bool) {
        let (canUse, error) = canUseBiometricService()
        if canUse {
            UserDefaults.standard.set(enabled, forKey: biometricStateKey)
        } else if let error = error {
            print("\(#function) ", error.localizedDescription)
        }
    }
    
    func canUseBiometricService() -> (Bool, NSError?) {
        let context = LAContext()
        var authError: NSError?
        let canUse = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError)
        if canUse {
            cachedBiometricType = context.biometryType
        }
        return (canUse, authError)
    }
    
    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        let (canUse, error) = canUseBiometricService()
        guard canUse else {
            completion(false, error)
            return
        }
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Use Passcode"
        let reason = "Please authenticate to use the app"

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
            completion(success, evaluateError)
        }
    }
}
