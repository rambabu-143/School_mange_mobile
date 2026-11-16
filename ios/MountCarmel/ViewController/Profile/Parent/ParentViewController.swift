//
//  ParentViewController.swift
//  MountCarmel
//
//  Created by Sandip on 27/07/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet weak var navigationView: NavigationBarView!
    var objGeneralProfileData : StudentDetailData?
    private var ArrRelation = [Relation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Parent"
        navigationView.delegate = self
        
        self.ArrRelation = (objGeneralProfileData?.relation ?? []).sorted { ($0.relation ?? "") < ($1.relation ?? "")}
    }
   // BOUPK89878
    @IBAction func btnEdit(_ sender: UIButton) {
        let vc = UIStoryboard(name: "ParentViewController", bundle: nil).instantiateViewController(withIdentifier: "EditParentViewController") as! EditParentViewController
        
        vc.modalPresentationStyle = .overFullScreen
        
        vc.arrObjRelation = self.ArrRelation
        vc.selectedRelationIndex = sender.tag
      //  print(obj?.first?.occupation_id?.occupation_name)
        vc.submitHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.navigationController?.popViewController(animated: true)

            }
        }
        
        self.present(vc, animated: true)
    }
}

extension ParentViewController: NavigationBarViewDelegate {
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
extension ParentViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ArrRelation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "ParentTablecell", for: indexPath) as? ParentTablecell
        if(self.ArrRelation.count != 0){
            cell?.setUpCellData(objData: ArrRelation[indexPath.row])
        }
        cell?.btnEdit.tag = indexPath.row
        cell?.btnEdit.isHidden = !(APP_DELEGATE.userType == LoginType.Parent)
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
