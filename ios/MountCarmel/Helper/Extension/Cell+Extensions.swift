//
//  Cell+Extensions.swift
//  DramG
//
//  Created by Niraj on 25/01/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
import UIKit

protocol NibInstantiable {
    static var nibInstance: UINib { get }
}

extension NibInstantiable where Self: UIView {
    
    static var cellId: String {
        return String(describing: self)
    }
    
    static var bundle: Bundle {
        return Bundle(for: self)
    }
    
    static var nibInstance: UINib {
        return UINib(nibName: cellId, bundle: bundle)
    }
}

extension UITableViewCell: NibInstantiable {
    static func register(with tableView: UITableView) {
        tableView.register(nibInstance, forCellReuseIdentifier: cellId)
    }
}
extension UICollectionViewCell: NibInstantiable {
    static func register(with collectionView: UICollectionView) {
        collectionView.register(nibInstance, forCellWithReuseIdentifier: cellId)
    }
}
