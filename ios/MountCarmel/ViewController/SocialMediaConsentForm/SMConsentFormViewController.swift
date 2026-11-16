//
//  SMConsentFormViewController.swift
//  MountCarmel
//
//  Created by Jatin Nagar on 14/03/26.
//  Copyright © 2026 Mount Carmel Schools. All rights reserved.
//

import UIKit

@objc class SMConsentFormViewController: UIViewController, DismissibleWithResult {
    var policyUri: String?

    // Define the closure as an @objc compatible block
    @objc var onDismissWithResult: ((Bool) -> Void)?
}
