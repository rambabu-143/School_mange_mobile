//
//  PopUpViewController.swift
//  MountCarmel
//
//  Created by Sandip on 07/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet var lblFor: UILabel!
    @IBOutlet var lblReasonTitle: UILabel!
    @IBOutlet var btnOK: RoundedButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtDescription: GrowingTextView!
    @IBOutlet var lbl1: UILabel!

    var doneHandler : ((String) -> ())?
    var strTitle = ""
    override func viewDidLoad() {
        lblTitle.text = strTitle
        super.viewDidLoad()
        self.txtDescription.font = UIFont.setRegularFont(ofSize: 12.0)
        self.lblTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblFor.font = UIFont.setBoldFont(ofSize: 12.0)
        self.lblReasonTitle.font = UIFont.setBoldFont(ofSize: 12.0)
        self.btnOK.titleLabel?.font = UIFont.setBoldFont(ofSize: 12.0)
        txtDescription.becomeFirstResponder()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBackViewClick(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func actionYesClick(_ sender: Any) {
        self.view.endEditing(true)
        if(txtDescription.text != ""){
            self.dismiss(animated: true, completion: {
                if(self.doneHandler != nil){
                    self.doneHandler!(self.txtDescription.text)
                }
            })
        }else {
            self.toast("Please enter information")
        }
        
    }
    
    @IBAction func actionNoClick(_ sender: Any) {
         self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionClosePopUp(_ sender: Any) {
         self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension PopUpViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if updatedText.count <= 80 {
            
            lbl1.text = "\(updatedText.count)/80"
            return true
        }
        else {
            return false
        }
    }
}
