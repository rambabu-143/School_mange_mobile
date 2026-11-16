//
//  ClassListCell.swift
//  MountCarmel
//
//  Created by Niraj on 05/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ClassListCell: UITableViewCell {

    @IBOutlet var btnInformation: UIButton!
    @IBOutlet var txtInformation: RoundTextField!
    //    @IBOutlet var txtInformation: GrowingTextView!
    @IBOutlet var btnReason: UIButton!
    @IBOutlet var txtReason: RoundTextField!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblID: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn1: UIButton!
    @IBOutlet var viewBottom: UIView!
    @IBOutlet var viewButton: UIView!
    @IBOutlet weak var cardView: RoundedView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var otherReasonView: RoundedView!{didSet{otherReasonView.isHidden = true}}
    @IBOutlet weak var otherReasonTextField: RoundTextField!
    var viewController : MarkAttendenceDetailViewController?
    var viewController2 : SubmitAttendancePopUp?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont.setRegularFont(ofSize: 12.0)
        lblID.font = UIFont.setRegularFont(ofSize: 11.0)
        
        txtInformation.font = UIFont.setRegularFont(ofSize: 11.0)
        txtReason.font = UIFont.setRegularFont(ofSize: 11.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn1Clicked(_ sender: Any) {
        viewController?.btn1Click(cell: self)
        viewController2?.btn1Click(cell: self)
    }
    
    @IBAction func btn2Clicked(_ sender: Any) {
        viewController?.btn2Click(cell: self)
        viewController2?.btn2Click(cell: self)
    }
    
    @IBAction func selectInformation(_ sender: Any) {
        viewController2?.selectInformationData(cell: self)
    }
    
    @IBAction func selectReason(_ sender: Any) {
        viewController2?.selectReasonData(cell: self)
    }
    
    func setUpCell(data : HouseReportData, path:String){
        lblName.text = data.name
        lblID.text = data.admission_no
       // let urlPath = APP_DELEGATE.urlPath + "/"
      //  let imageURL = urlPath + "/" + (data.profilepic ?? "")
        //studentImageIssue
        let imageURL = path+(data.profile_pic ?? "")
        self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
    }
    
    func setUpCell(data : SelectedStudentAttendenceModel/*MarkAttendanceListData*/ , path : String){
        //txtInformation.delegate = self
        lblName.text = data.name
        lblID.text = data.admission_no
        //studentImageIssue
        let imageURL = path+(data.profile_pic ?? "")
        self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        
        if let reason = data.reason, reason != ""{
            txtReason.text = reason
            otherReasonView.isHidden = reason == "Others" ? false : true
        }else{
            txtReason.text = "Select Reason"
            otherReasonView.isHidden = true
        }
        
        if let information = data.information, information != ""{
            txtInformation.text = information
        }else{
            txtInformation.text = "Information Received"
        }
        
        if let details = data.details, details != ""{
            otherReasonTextField.text = details
        }else{
            otherReasonTextField.text = ""
        }
        
      /*  if let selectedData = data.attendance{
            btn1.isUserInteractionEnabled = false
            btn2.isUserInteractionEnabled = false
            if(selectedData.type == "full"){
                btn1.isSelected = true
                btn2.isSelected = true
            }else if(selectedData.type == "first"){
                btn1.isSelected = true
                btn2.isSelected = false
                
            }else if(selectedData.type == "second"){
                btn1.isSelected = false
                btn2.isSelected = true
            }
        }else{
            btn1.isUserInteractionEnabled = true
            btn2.isUserInteractionEnabled = true
        }*/
        
    }
}
extension ClassListCell: UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView) {
       
    }
    func textViewDidEndEditing(_ textView: UITextView) {
         viewController2?.selectInformation(cell:self)
    }
}
