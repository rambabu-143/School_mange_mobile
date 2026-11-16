//
//  MyTeacherViewController.swift
//  MountCarmel
//
//  Created by Sandip on 08/11/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class MyTeacherViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!
    
    @IBOutlet var tblView: UITableView!
    var MyteacherResponseData : MyTeacherResponse?
    var arrClassTeacher = [TeacherTypeData]()
    var arrSubjectTeacher = [Subjects]()
    
    var showSurveyCTA = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "My Teachers"
        navigationView.delegate = self
        
        if let standardLabel = self.getStandard(from: APP_DELEGATE.selected_Student?.studentId?.standardId?.name ?? "") {
            self.showSurveyCTA = APP_DELEGATE.userType == .School && standardLabel >= 9
        }
        
        self.configureTableView()
        getInitialData()
        // Do any additional setup after loading the view.
    }
    
    func configureTableView() {
        // Register Cell
        let cellNib = UINib(nibName: String(describing: MyTeacherTableViewCell.self), bundle: nil)
        self.tblView.register(cellNib, forCellReuseIdentifier: MyTeacherTableViewCell.cellId)
    }
    
    func getInitialData(){
        self.callMyTeacherAPI { (check) in
            if check{
               
              /*  guard let houseData = self.MyteacherResponseData?.house?.house_incharge_id else {
                    return
                }*/
                
                if let classData = self.MyteacherResponseData?.classData?.class_teacher_id{
                    classData.type = "Class Teacher"
                    self.arrClassTeacher.append(classData)
                }
                
                if let helperData = self.MyteacherResponseData?.classData?.helper_teacher_id{
                    helperData.type = "Helper Teacher"
                    self.arrClassTeacher.append(helperData)
                }
                
                if let houseData = self.MyteacherResponseData?.house?.house_incharge_id{
                    if houseData.count > 0{
                        for h_d in houseData{
                            h_d.type = "House Teacher"
                            self.arrClassTeacher.append(h_d)
                        }
                       // houseData[0].type = "House Teacher"
                        //self.arrClassTeacher.append(houseData[0])
                    }                    
                }
                
                self.arrSubjectTeacher = self.MyteacherResponseData?.subjects ?? [Subjects]()
                self.tblView.reloadData()
            }
        }
    }

    func teacherEvaluationProgram(teacher: Subjects) {
    }
}
extension MyTeacherViewController: NavigationBarViewDelegate {
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
extension MyTeacherViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return arrClassTeacher.count
        } else{
            return self.arrSubjectTeacher.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTeacherTableViewCell.cellId, for: indexPath) as! MyTeacherTableViewCell
        if(indexPath.section == 0){
            cell.backView.backgroundColor = #colorLiteral(red: 0.8406969905, green: 0.8407167792, blue: 0.8407061696, alpha: 1)
            cell.lblName.text = arrClassTeacher[indexPath.row].name ?? ""
            cell.lblPost.text = arrClassTeacher[indexPath.row].type ?? ""
            let url = (MyteacherResponseData?.path ?? "") + "/" + (arrClassTeacher[indexPath.row].profile_pic ?? "")
            
            cell.imgProfile.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
            cell.onPress = nil
            cell.surveyCTA.isHidden = true
        }else{
            cell.backView.backgroundColor = .white
            let currentSubjectTeacher = arrSubjectTeacher[indexPath.row]
            cell.lblPost.text = currentSubjectTeacher.subject_name ?? ""
            
            if (currentSubjectTeacher.subject_teacher_id?.count != 0){
                cell.lblName.text = currentSubjectTeacher.subject_teacher_id?[0].staff_id?.name ?? ""
                let url = (MyteacherResponseData?.path ?? "") + "/" + (currentSubjectTeacher.subject_teacher_id?[0].staff_id?.profile_pic ?? "")
                
                cell.imgProfile.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
                
                if (showSurveyCTA) {
                    cell.onPress = { [weak self] in
                        self?.teacherEvaluationProgram(teacher: currentSubjectTeacher)
                    }
                    cell.surveyCTA.isHidden = false
                } else {
                    cell.onPress = nil
                    cell.surveyCTA.isHidden = true
                }
            }else{
                cell.imgProfile.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
                cell.lblName.text = ""
                cell.onPress = nil
                cell.surveyCTA.isHidden = true
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 1){
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "Subject Teacher"
            label.font = UIFont.setBoldFont(ofSize: 15.0) // my custom font
            label.textColor = UIColor.black // my custom colour
            
            headerView.addSubview(label)
            headerView.backgroundColor = .white
            return headerView
        }else{
            return UIView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 1){
            return 50
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- API CALL -

extension MyTeacherViewController{
    func callMyTeacherAPI(finished:@escaping(_ success: Bool) -> Void){
        Loader.show()
        StudentManagementAPI.getMyTeachers() { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "Invalid Response")
                //CommonFunctions.logOutFromAPP()
                finished(false)
                return
            }
            self.MyteacherResponseData = response
            finished(true)
        }
    }
    
    func getStandard(from roman: String) -> Int? {
        return switch roman {
        case "I": 1
        case "II": 2
        case "III": 3
        case "IV": 4
        case "V": 5
        case "VI": 6
        case "VII": 7
        case "VIII": 8
        case "IX": 9
        case "X": 10
        case "XI": 11
        case "XII": 12
        case "XIII": 13
        case "XIV": 14
        case "XV": 15
        default: nil
        }
    }
}
