//
//  ProfileQualificationCell.swift
//  MountCarmel
//
//  Created by Sandip on 07/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ProfileQualificationCell: UITableViewCell {

    @IBOutlet var lblSchoolName: UILabel!
    @IBOutlet var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblSchoolName.font = UIFont.setRegularFont(ofSize: 14.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
