//
//  CustomDropDown.swift
//  MountCarmel
//
//  Created by Sandip on 31/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class DropDownCell : UITableViewCell{
    
    @IBOutlet var btnName: UIButton!
}

class CustomDropDown: UIViewController {

    @IBOutlet var btnDone: RoundedButton!
    @IBOutlet var btnSelectAll: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var conTblHeight: NSLayoutConstraint!
    @IBOutlet var tblView: UITableView!
    var arrItems = [String]()
    var arrSelectedItem = [Int]()
    var doneHandler: (([Int]) -> ())?
    var strTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = strTitle
        self.lblTitle.font = UIFont.setBoldFont(ofSize: 13.0)
        btnDone.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
        btnSelectAll.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        if(self.arrSelectedItem.count == 0){
            for _ in 0..<self.arrItems.count{
                self.arrSelectedItem.append(0)
            }
        }
      
        self.tblView.reloadData()
        self.view.layoutIfNeeded()
        self.conTblHeight.constant = self.tblView.contentSize.height
        self.view.layoutIfNeeded()
        
        // Do any additional setup after loading the view.
    }
    

   //Mark:- Action Event -
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func actionSelectAll(_ sender: UIButton) {
        self.arrSelectedItem.removeAll()
        if(!sender.isSelected){
            sender.isSelected = true
            for _ in 0..<self.arrItems.count{
                self.arrSelectedItem.append(1)
            }
        }else{
            sender.isSelected = false
            for _ in 0..<self.arrItems.count{
                self.arrSelectedItem.append(0)
            }
        }
       
        self.tblView.reloadData()
    }
    @IBAction func actionDone(_ sender: Any) {
        let check = self.arrSelectedItem.contains(1)
        if(check){
            self.dismiss(animated: false) {
                if self.doneHandler != nil{
                    self.doneHandler!(self.arrSelectedItem)
                }
            }
        }else{
            self.toast("Please select class")
        }
        
        
    }
}
extension CustomDropDown: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.arrSelectedItem[indexPath.row] == 1){
            self.arrSelectedItem[indexPath.row] = 0
        }else{
            self.arrSelectedItem[indexPath.row] = 1
        }
        self.tblView.reloadData()
    }
}

extension CustomDropDown: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as! DropDownCell
        cell.btnName.setTitle(self.arrItems[indexPath.row], for: .normal)
        cell.btnName.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
        
        if(self.arrSelectedItem[indexPath.row] == 1){
            cell.btnName.isSelected = true
        }else{
            cell.btnName.isSelected = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
