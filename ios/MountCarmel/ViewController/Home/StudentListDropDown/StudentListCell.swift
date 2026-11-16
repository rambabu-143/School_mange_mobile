//
//  StudentListCell.swift
//  MountCarmel
//
//  Created by Sandip on 30/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class StudentListCell: UITableViewCell {

    @IBOutlet var lblStudentName: UILabel!
    @IBOutlet var imgProfile: RoundedImage!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
