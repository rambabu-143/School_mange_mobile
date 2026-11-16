//
//  DisciplinaryCardDetailPopUp.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 10/06/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit
import ScalingCarousel

class DisciplinaryCardDetailPopUp: UIViewController {
    @IBOutlet weak var clcVIew: ScalingCarouselView!{
        didSet{
            clcVIew.delegate = self
            clcVIew.dataSource = self
        }
    }
    
internal var arrSubData = [colorSubData]()
    internal var cardType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clcVIew.inset = 0
    }

}

extension DisciplinaryCardDetailPopUp: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = clcVIew.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DisplinaryClcCell
        
        cell.viewCard.borderColor = UIColor(named: "Dis_\(cardType)")!

        if cardType == "Pink"{
            //cell.roundUpperLabel.text = "W"
            cell.lblHeading.text = "WARNING CARD"

        }else if cardType == "Yellow"{
            //cell.roundUpperLabel.text = "T"
            cell.lblHeading.text = "TARDY CARD"

        }else{//Red
           // cell.roundUpperLabel.text = "R"
            cell.lblHeading.text = "RED CARD"
        }

        let M = arrSubData[indexPath.item]
        cell.lblIssuedTo.text = "\(M.student_id?.name ?? "") (\(M.student_id?.admission_no ?? "")) \(M.student_id?.standard_section_id?.standard ?? "")\(M.student_id?.standard_section_id?.section ?? "")"
        
        cell.lblFor.text = (M.reason_other ?? "") == "" ? (M.reason ?? "") : (M.reason_other ?? "")
        
        //cell.lblFor.text = (M.reason ?? "") + ((M.reason_other ?? "") == "" ? "" : (", "+(M.reason_other ?? "")))
        cell.lblActionTaken.text = M.action_taken ?? ""
        cell.lblHousePOints.text = "\(M.house_point ?? 0) (\(M.student_id?.house_id?.house_no ?? ""))"
        cell.lblTeacherNAme.text = M.staff_id?.name ?? ""
        cell.lblDate.text = CommonFunctions.getDateString(date: M.issue_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.ddMMMyyyy)
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
}

extension DisciplinaryCardDetailPopUp: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //carousel.didScroll()
        
        guard let currentCenterIndex = clcVIew.currentCenterCellIndex?.row else { return }
    }
}

extension DisciplinaryCardDetailPopUp: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height - 10)
    }
    
}

class DisplinaryClcCell:UICollectionViewCell{
    //@IBOutlet weak var roundUpperView: RoundedView!
   // @IBOutlet weak var roundUpperLabel: UILabel!
    
    @IBOutlet weak var viewCard: ViewCustom!
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var lblIssuedTo: UILabel!
    @IBOutlet weak var lblFor: UILabel!
    @IBOutlet weak var lblActionTaken: UILabel!
    @IBOutlet weak var lblHousePOints: UILabel!
    @IBOutlet weak var lblTeacherNAme: UILabel!
    @IBOutlet weak var lblDate: UILabel!
}
