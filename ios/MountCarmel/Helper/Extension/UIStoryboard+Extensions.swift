//
//  UIStoryboard+Extensions.swift
//  DramG
//
//  Created by Niraj on 04/02/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

extension UIStoryboard {

    /// Instantiate view controller with generics
    func initialize<T: UIViewController>() -> T? {
        if let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T {
            return viewController
        }
        
        return nil
    }
}

/// Create `UIViewController` extension to conform to `StoryboardIdentifiable`
extension UIViewController: StoryboardInstantiable {
}

// MARK: UIViewControllers identifiers
/// Protocol to give any class that conform it a static variable `storyboardIdentifier`
protocol StoryboardInstantiable {
    static var storyboardInstance: UIStoryboard { get }
}

/// Protocol extension to implement `storyboardIdentifier` variable only when `Self` is of type `UIViewController`
extension StoryboardInstantiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }

    static var storyboardInstance: UIStoryboard {
        return UIStoryboard(name: storyboardIdentifier, bundle: nil)
    }
}

