//
//  WiseClassListCell.swift
//  MountCarmel
//
//  Created by Sandip on 07/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class WiseClassListCell: UITableViewCell {
    var viewController : ClassViewController?
    
    @IBOutlet var lblEmotionTitle: UILabel!
    @IBOutlet var lblSatureTitle: UILabel!
    @IBOutlet var lblIntellectTitle: UILabel!
    @IBOutlet var lblWorthyTitle: UILabel!
    @IBOutlet var btn4: RoundedButton!
    @IBOutlet var btn1: RoundedButton!
    @IBOutlet var lblReason: UILabel!
    @IBOutlet weak var lblStaticFor: UILabel!
    @IBOutlet var viewLine: UIView!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var lblId: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgProfile: RoundedImage!
    @IBOutlet var lblIndex: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblName.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblIndex.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblId.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblReason.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblStaticFor.font = UIFont.setRegularFont(ofSize: 13.0)
        
        self.lblEmotionTitle.font = UIFont.setRegularFont(ofSize: 9.0)
        self.lblSatureTitle.font = UIFont.setRegularFont(ofSize: 9.0)
        self.lblIntellectTitle.font = UIFont.setRegularFont(ofSize: 9.0)
        self.lblWorthyTitle.font = UIFont.setRegularFont(ofSize: 9.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Action Event-
    
    @IBAction func btn1Click(_ sender: Any) {
        viewController?.btn1Click(title : "Worthy Card" , cell : self)
    }
    @IBAction func btn2Click(_ sender: RoundedButton) {
       
        viewController?.btn2Click(title : "Intellect Card" , cell : self)
    }
    
    @IBAction func btn3Click(_ sender: RoundedButton) {
       
         viewController?.btn3Click(title : "Stature Card" , cell : self)
    }
    @IBAction func btn4Click(_ sender: Any) {
       viewController?.btn4Click(title : "Emotion Card" , cell : self)
    }
    
    func setUpCell(data : HouseReportData , path : String){
        lblName.text = data.name
        lblId.text = data.admission_no
        
        let imageUrl = path+(data.profile_pic ?? "")
        //studentImageIssue
        self.imgProfile.sd_setImage(with: URL(string:imageUrl), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        
    }
}
