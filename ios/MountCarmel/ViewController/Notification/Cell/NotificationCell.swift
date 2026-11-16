//
//  NotificationCell.swift
//  MountCarmel
//
//  Created by Niraj on 05/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblMessageDetais: UILabel!
    
    @IBOutlet var btnMore: UIButton!
    @IBOutlet var lblDate: UILabel!
    var viewController: NotificationViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblMessageDetais.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblDate.font = UIFont.setRegularFont(ofSize: 11.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCellData(data: MessageData){
        
       // self.lblSubject.font = UIFont.setBoldFont(ofSize: 15.0)
        self.lblMessageDetais.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblDate.font = UIFont.setRegularFont(ofSize: 11.0)
        
       // lblSubject.text = data.sms_type
        lblMessageDetais.text = data.sms_text
        lblDate.text = CommonFunctions.UTCToLocal(date: data.created_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Notice)
        
        if data.read_flag == true{
            imgIcon.image = #imageLiteral(resourceName: "notification02")
        }else{
            imgIcon.image = #imageLiteral(resourceName: "notification01")
        }
    }
    
    @IBAction func actionViewMore(_ sender: UIButton) {
        viewController?.viewMoreClick(messageIndex : sender.tag)
    }
}
