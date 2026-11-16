//
//  HomeScreenCell.swift
//  MountCarmel
//
//  Created by Niraj on 07/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class HomeScreenCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var viewBg: RoundedView!
    
    @IBOutlet weak var viewNotification: UIView!{
        didSet{
            viewNotification.layer.cornerRadius = 25.0/2.0
            viewNotification.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblNotification: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.setRegularFont(ofSize: 14.0)
        // Initialization code
    }

}
