//
//  TimeTableCell.swift
//  MountCarmel
//
//  Created by Sandip on 08/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class TimeTableCell: UITableViewCell {

    @IBOutlet var viewCount: RoundedView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        
        self.lblTime.font = UIFont.setRegularFont(ofSize: 14.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
