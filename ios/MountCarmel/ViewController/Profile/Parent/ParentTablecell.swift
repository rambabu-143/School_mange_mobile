//
//  ParentTablecell.swift
//  MountCarmel
//
//  Created by Sandip on 27/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ParentTablecell: UITableViewCell {
    
    @IBOutlet var lblTitles: [UILabel]!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblQualification: UILabel!
    @IBOutlet var lblOccupation: UILabel!
    @IBOutlet var lblOrganizationName: UILabel!
    @IBOutlet var lblDesignation: UILabel!
    @IBOutlet var lblPanNo: UILabel!
    @IBOutlet var lblOfficeAddress: UILabel!
    @IBOutlet var lblOfficeNo: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblMobileNo: UILabel!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for lbl in lblTitles{
            lbl.font = UIFont.setRegularFont(ofSize: 13.0)
        }
        self.lblTitle.font = UIFont.setBoldFont(ofSize: 13.0)
        self.lblName.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblQualification.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblOccupation.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblOrganizationName.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblDesignation.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblPanNo.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblOfficeAddress.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblOfficeNo.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblEmail.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblMobileNo.font = UIFont.setRegularFont(ofSize: 13.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCellData(objData : Relation){
        self.lblTitle.text = objData.relation
        self.lblName.text = objData.name
        self.lblMobileNo.text = objData.mobile
        self.lblEmail.text = objData.email
        self.lblOfficeNo.text = objData.office_phone
        self.lblPanNo.text = objData.pancard
        self.lblOccupation.text = (objData.occupation_id?.occupation_name ?? "")
        
        if (objData.occupation_child_id?.occupation_child_name ?? "") != ""{
            self.lblOccupation.text = self.lblOccupation.text! + ", " + (objData.occupation_child_id?.occupation_child_name ?? "")
        }
        if (objData.other_occupation ?? "") != ""{
            self.lblOccupation.text = self.lblOccupation.text! + ", " + (objData.other_occupation ?? "")
        }
        
        self.lblOrganizationName.text = objData.organization
        self.lblDesignation.text = objData.designation
        self.lblOfficeAddress.text = objData.office_address
        self.lblQualification.text = objData.qualification_id?.qualification ?? ""
    }

}
