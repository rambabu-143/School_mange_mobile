//
//  SchoolCalendarCell.swift
//  MountCarmel
//
//  Created by Niraj on 12/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SchoolCalendarCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblDate.font = UIFont.setRegularFont(ofSize: 11.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
