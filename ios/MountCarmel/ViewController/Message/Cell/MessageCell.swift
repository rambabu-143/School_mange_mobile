//
//  MessageCell.swift
//  MountCarmel
//
//  Created by Niraj on 04/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet var btnMore: UIButton!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblMessageDetais: UILabel!
    @IBOutlet weak var massegeImage: UIImageView!
    var viewController: MessageViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(data: MessageData){
        
        self.lblSubject.font = UIFont.setBoldFont(ofSize: 15.0)
        self.lblMessageDetais.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblDateTime.font = UIFont.setRegularFont(ofSize: 11.0)
        
        lblSubject.text = data.sms_type
        lblMessageDetais.text = data.sms_text
        lblDateTime.text = CommonFunctions.UTCToLocal(date: data.created_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Notice)
        
        if let mobilesData = data.mobilesData{
            if mobilesData.count > 0{
                if mobilesData[0].read_flag == true{
                    massegeImage.image = #imageLiteral(resourceName: "message-read")
                }else{
                    massegeImage.image = #imageLiteral(resourceName: "meaasge01")
                }
            }
        }
       
//            if data.read_flag == true{
//                massegeImage.image = #imageLiteral(resourceName: "message-read")
//            }else{
//                massegeImage.image = #imageLiteral(resourceName: "meaasge01")
//            }
        
    }
    
    @IBAction func actionMoreClick(_ sender: UIButton) {
        viewController?.viewMoreClick(messageIndex : sender.tag)
    }
}
