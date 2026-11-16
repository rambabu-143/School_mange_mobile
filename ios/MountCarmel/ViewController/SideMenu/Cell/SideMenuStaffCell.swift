//
//  SideMenuStaffCell.swift
//  MountCarmel
//
//  Created by Niraj on 03/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SideMenuStaffCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var lblNotification: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.setRegularFont(ofSize: 11.0)
        // Initialization code
        
        viewNotification.layer.cornerRadius = 25/2
        viewNotification.clipsToBounds = true
        viewNotification.isHidden = true
    }

}
