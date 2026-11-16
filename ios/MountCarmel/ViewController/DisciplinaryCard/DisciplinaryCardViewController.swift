//
//  DisciplinaryCardViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 10/06/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit

class DisciplinaryCardViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!
    
    @IBOutlet weak var lblPinkCardCOunt: UILabel!
    @IBOutlet weak var lblYellowCardCOunt: UILabel!
    @IBOutlet weak var lblRedCardCOunt: UILabel!
    
    private var objDiscplinaryData:DisciplinatyData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Disciplinary Card"
        navigationView.delegate = self
        
        
        self.callAPIGetDisiplinatyCardList { success in
            self.lblPinkCardCOunt.text = "(\(self.objDiscplinaryData?.pink?.count ?? 0))"
            self.lblYellowCardCOunt.text = "(\(self.objDiscplinaryData?.yellow?.count ?? 0))"
            self.lblRedCardCOunt.text = "(\(self.objDiscplinaryData?.red?.count ?? 0))"
        }
    }
    
    @IBAction func btnViewAction(_ sender: UIButton) {
        var subData = [colorSubData]()
        var cardType = ""
        switch sender.tag{
        case 0:
            subData = objDiscplinaryData?.pink?.data ?? []
            cardType = "Pink"
            break;
        case 1:
            subData = objDiscplinaryData?.yellow?.data ?? []
            cardType = "Yellow"
            break;
        case 2:
            subData = objDiscplinaryData?.red?.data ?? []
            cardType = "Red"
            break;
        default:
            break;
        }
        
        guard subData.count != 0 else{
            self.toast("No cards")
            return
        }
        
        let vc = UIStoryboard(name: "DisciplinaryCardViewController", bundle: nil).instantiateViewController(withIdentifier: "DisciplinaryCardDetailPopUp") as! DisciplinaryCardDetailPopUp
        vc.arrSubData = subData
        vc.cardType = cardType
        self.navigationController?.present(vc, animated: true)
        
    }
    
}


extension DisciplinaryCardViewController{
    private func callAPIGetDisiplinatyCardList(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StudentManagementAPI.getDisiplinatyCardList(admisionNO: APP_DELEGATE.selected_Student?.admissionNo ?? "") { (response, error) in
            Loader.hide()
            guard let response = response else {
                let _ = error?.localizedDescription ?? "Invalid Response"
                finished(false)
                return
            }
            guard let DData = response.data else{
                self.toast(response.message ?? "No data found!!")
                return
            }
            self.objDiscplinaryData = DData
            finished(response.status ??  false)
        }
    }
}

extension DisciplinaryCardViewController: NavigationBarViewDelegate {
func onTapDropDown() {
    
}
func onTapMenu() {
    
}

func onTapBack() {
    
    if self.navigationController?.viewControllers.count ?? 0 == 1 {
        self.setHomeScreen()
    }else {
        self.navigationController?.popViewController(animated: true)
    }
}

func onTapNotification() {
    if let viewController: NotificationViewController = NotificationViewController.storyboardInstance.initialize() {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

func onTapBadgeCounts() {
    if let viewController: NotificationViewController = NotificationViewController.storyboardInstance.initialize() {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

func onTapAppLogo() {
    let viewcontrollers = self.navigationController?.viewControllers
    var flag = true
    viewcontrollers?.forEach({ (vc) in
        if  let viewController = vc as? HomeViewController {
            flag = false
            self.navigationController!.popToViewController(viewController, animated: true)
        }
    })
    
    if flag {
        self.setHomeScreen()
    }
}
func onTapStory() {
    print(#function)
}
func setHomeScreen() {
    if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
        let contentViewController = UINavigationController(rootViewController: viewController)
        contentViewController.navigationBar.isHidden = true
        self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
    }
}
}

struct DisciplinatyModel:Codable{
    let data:DisciplinatyData?
    let message:String?
    let status:Bool?
}

struct DisciplinatyData:Codable{
    let pink:colorData?
    let red:colorData?
    let yellow:colorData?
}

struct colorData:Codable{
    let count:Int?
    let data:[colorSubData]?
}

struct colorSubData:Codable{
    let _id:String?
    let action_taken:String?
    let admission_no:String?
    let branch_code:Int?
    let house_point:Int?
    let issue_date:String?
    let pink:Int?
    let reason:String?
    let reason_other:String?
    let red:Int?
    let school_code:String?
    let year_session:String?
    let yellow:Int?
    let staff_id:staff_id?
    let student_id:student_id?
}
struct staff_id:Codable{
    let name:String?
}
struct student_id:Codable{
    let name:String?
    let admission_no:String?
    let house_id:house_id?
    let standard_section_id:standard_section_id?
}
struct house_id:Codable{
    let house_no:String?
}
struct standard_section_id:Codable{
    let section:String?
    let standard:String?
}

