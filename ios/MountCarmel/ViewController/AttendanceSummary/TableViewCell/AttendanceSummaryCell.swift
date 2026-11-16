//
//  AttendanceSummaryCell.swift
//  MountCarmel
//
//  Created by Sandip on 08/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class AttendanceSummaryCell2:UITableViewCell{
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var btnSection: UIButton!
    var buttonAction: ((AttendanceSummaryCell2) -> Void)?
    
    @IBAction func btnSectionAction(_ sender: UIButton) {
        self.buttonAction?(self)
    }
}
class AttendanceExpendedCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblReason: UILabel!
}
/*
class AttendanceSummaryCell: UITableViewCell {

    @IBOutlet var tblHeight: NSLayoutConstraint!
    @IBOutlet var expandedView: UIView!
    @IBOutlet var tblExpanded: UITableView!
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    
    var arrAttandenceSummery = [AttendanceSummaryData]()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTitle.font = UIFont.setBoldFont(ofSize: 13.0)
        lblDate.font = UIFont.setRegularFont(ofSize: 13.0)
        
        tblExpanded.register(UINib(nibName: "ExpandedTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpandedTableViewCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(isExpand : Bool){
        tblExpanded.delegate = self
        tblExpanded.dataSource = self
        tblExpanded.reloadData()
        
        if(isExpand){
            self.layoutIfNeeded()
            self.tblHeight.constant = (self.tblExpanded.contentSize.height)
            self.layoutIfNeeded()
            
            self.layoutIfNeeded()
            self.tblHeight.constant = (self.tblExpanded.contentSize.height)
            self.layoutIfNeeded()
            
            tblExpanded.reloadData()
        }else{
            
        }
        
    }
    func setUpDisplayData(arrdata : [AttendanceSummaryData],indexpath:IndexPath){
        let data = arrdata[indexpath.row]
        
        let strClass = (data.standard ?? "") + " " + (data.section ?? "")
        let title = " " + "\(data.total_absent ?? 0)"
        if(data.total_absent == 0){
           // let strTitle = "  All Present"
            self.lblTitle.text = strClass
        }else{
            let strTitle = "  absent/" + "\(data.total_student ?? 0)"
            self.lblTitle.text = strClass + title + strTitle
        }
        
        if((data.is_attendance_marked ?? false) == true){
            let strDate = CommonFunctions.UTCToLocal(date: data.attendance_marked_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Notice)
            
            self.lblDate.text = strDate
        }else{
            let strDate = CommonFunctions.UTCToLocal(date: data.created_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Notice)
            
            self.lblDate.text = "Attendance Not Marked"
        }
        
        self.arrAttandenceSummery = arrdata
    }
}

extension AttendanceSummaryCell : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAttandenceSummery[section].students?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblExpanded.dequeueReusableCell(withIdentifier: "ExpandedTableViewCell", for: indexPath) as? ExpandedTableViewCell
        let studentData = self.arrAttandenceSummery[indexPath.section].students?[indexPath.row]
        cell?.lblTitle.text = (studentData?.student_id?.admission_no ?? "") + " - " + (studentData?.student_id?.name ?? "")
        cell?.lblReason.text = studentData?.reason ?? ""
        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

*/
