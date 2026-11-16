//
//  ProfileDepartmentCell.swift
//  MountCarmel
//
//  Created by Sandip on 04/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ProfileDepartmentCell: UICollectionViewCell {
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var viewBack: RoundedView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        // Initialization code
    }

}
