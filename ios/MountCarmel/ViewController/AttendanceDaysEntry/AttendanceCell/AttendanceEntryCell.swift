//
//  AttendanceEntryCell.swift
//  MountCarmel
//
//  Created by Sandip on 05/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class AttendanceEntryCell: UITableViewCell {

    @IBOutlet var lblPreTitle: UILabel!
    @IBOutlet var lblPercentage: UILabel!
    @IBOutlet var lblTotalPresentTitle: UILabel!
    @IBOutlet var lblTotalPresent: UILabel!
    @IBOutlet var lblId: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgProfile: RoundedImage!
    @IBOutlet var lblIndex: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblName.font = UIFont.setRegularFont(ofSize: 15.0)
        self.lblId.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblTotalPresent.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblTotalPresentTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        
        self.lblPreTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblPercentage.font = UIFont.setRegularFont(ofSize: 13.0)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
