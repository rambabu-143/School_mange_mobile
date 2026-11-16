//
//  ClassCollectionCell.swift
//  MountCarmel
//
//  Created by Sandip on 31/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ClassCollectionCell: UICollectionViewCell {

    var viewController: HouseListViewController?
    
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var btnTitle: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actionClose(_ sender: Any) {
         viewController?.deleteRecord(cell: self)
    }
}
