//
//  NoticeCell.swift
//  MountCarmel
//
//  Created by Niraj on 04/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblDate.font = UIFont.setRegularFont(ofSize: 12.0)
        self.lblDesc.font = UIFont.setRegularFont(ofSize: 14.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCellData(data : NoticeData){
        lblDesc.text = data.title
        lblDate.text = CommonFunctions.getDateString(date: data.created_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Notice)
        
    }
    
    func setUpStaffCellData(data : StaffNoticeList){
        lblDesc.text = data.title
        lblDate.text = CommonFunctions.getDateString(date: data.created_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Notice)
        
    }
    
}
