//
//  TabBarView.swift
//  MountCarmel
//
//  Created by Niraj on 03/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

protocol TabBarViewDelegate: class {
    func onTapSettings()
    func onTapNotice()
    func onTapProfile()
    func onTapMessages()
    func onTapFee()
}

class TabBarView: UIView {

    @IBOutlet weak var btnFee: UIButton!
    @IBOutlet weak var btnMessages: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnNotice: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    
    @IBOutlet weak var lblSettings: UILabel!
    @IBOutlet weak var lblNotice: UILabel!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    
    @IBOutlet var container: RoundedView!
    @IBOutlet var profileView: UIView!
    @IBOutlet var imgProfile: UIImageView!
    
    weak var delegate: TabBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initilize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initilize()
    }
    
    func initilize() {

        // Load the Nib
        Bundle.main.loadNibNamed(String(describing: TabBarView.self), owner: self, options: nil)
        
        // Make container fill the view frame
        self.container.frame = self.bounds
        
        self.container.clipsToBounds = false
        self.addSubview(self.container)

        self.clipsToBounds = false
        
        self.setRightTriangle()
        self.configureUIAccordingLoginType()
        
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUIAccordingLoginType() {
        
        if APP_DELEGATE.userType == LoginType.Parent {
            btnFee.setImage(UIImage.init(named: "long_out"), for: .normal)
            btnMessages.setImage(UIImage.init(named: "long_out"), for: .normal)
            //imgProfile.image = UIImage.init(named: "profile-image-4-12")
            btnNotice.setImage(UIImage.init(named: "teachers"), for: .normal)
            btnSettings.setImage(UIImage.init(named: "Settings"), for: .normal)
            
            lblFee.text = "Logout"
            lblSettings.text = "Settings"
            
            lblMessage.text = "Logout"
            lblProfile.text = "Profile"
            lblNotice.text = "My Teachers"
            
            _ = APP_DELEGATE.userInfo
            _ = APP_DELEGATE.urlPath
            
           // let imageURL = urlPath + (userInfo?.profilePic ?? "")
            //studentImageIssue
            let imageURL = (APP_DELEGATE.loginAPIResponse?.path ?? "") + (APP_DELEGATE.selected_Student?.studentId?.profile_pic ?? "")
            self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
            
        }else if APP_DELEGATE.userType == LoginType.School {
            btnFee.setImage(UIImage.init(named: "fees"), for: .normal)
            btnMessages.setImage(UIImage.init(named: "long_out"), for: .normal)
            imgProfile.image = UIImage.init(named: "profile-image-parents")
            btnNotice.setImage(UIImage.init(named: "teachers"), for: .normal)
            btnSettings.setImage(UIImage.init(named: "Settings"), for: .normal)
            
            lblFee.text = "fee"
            lblSettings.text = "Settings"
            
            lblMessage.text = "Logout"
            lblProfile.text = "Profile"
            lblNotice.text = "My Teachers"
            _ = APP_DELEGATE.urlPath
            //studentImageIssue
            let imageURL = (APP_DELEGATE.loginAPIResponse?.path ?? "") + (APP_DELEGATE.selected_Student?.studentId?.profile_pic ?? "")
            // let imageURL = urlPath + (APP_DELEGATE.userInfo?.profilePic ?? "")
            self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
            
        }else if APP_DELEGATE.userType == LoginType.Nursery {
            btnFee.setImage(UIImage.init(named: "long_out"), for: .normal)
            btnMessages.setImage(UIImage.init(named: "long_out"), for: .normal)
            imgProfile.image = UIImage.init(named: "profile-image-0-3")
            btnNotice.setImage(UIImage.init(named: "teachers"), for: .normal)
            btnSettings.setImage(UIImage.init(named: "Settings"), for: .normal)

            lblFee.text = "fee"
            lblSettings.text = "Settings"
            
            lblMessage.text = "Logout"
            lblProfile.text = "Profile"
            lblNotice.text = "My Teachers"
           // let urlPath = APP_DELEGATE.urlPath
            //studentImageIssue
            let imageURL = (APP_DELEGATE.loginAPIResponse?.path ?? "") + (APP_DELEGATE.selected_Student?.studentId?.profile_pic ?? "")
            // let imageURL = urlPath + (APP_DELEGATE.userInfo?.profilePic ?? "")
            self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        } else{
            btnFee.setImage(UIImage.init(named: "long_out"), for: .normal)
            btnMessages.setImage(UIImage.init(named: "long_out"), for: .normal)
            imgProfile.image = UIImage.init(named: "profile-image-0-3")
            btnNotice.setImage(UIImage.init(named: "fees"), for: .normal)
            btnSettings.setImage(UIImage.init(named: "Settings"), for: .normal)
            
            lblFee.text = "fee"
            lblSettings.text = "Settings"
            
            lblMessage.text = "Logout"
            lblProfile.text = "Profile"
            lblNotice.text = "Fee"
            
            let userInfo = APP_DELEGATE.userInfo
            let urlPath = (APP_DELEGATE.loginAPIResponse?.path ?? "") + "/"
            let imageURL = urlPath + (userInfo?.staffId?.profile_pic ?? "")
            self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
        }
        
        lblMessage.font = UIFont.setRegularFont(ofSize: 10.0)
        lblProfile.font = UIFont.setRegularFont(ofSize: 10.0)
        lblNotice.font = UIFont.setRegularFont(ofSize: 10.0)
        lblSettings.font = UIFont.setRegularFont(ofSize: 10.0)
        lblFee.font = UIFont.setRegularFont(ofSize: 10.0)
        
       
    }
    
    @IBAction func btnFeeTap(_ sender: Any) {
        delegate?.onTapFee()
    }
    
    @IBAction func btnMessageTap(_ sender: Any) {
        delegate?.onTapMessages()
    }
    
    @IBAction func btnProfileTap(_ sender: Any) {
        delegate?.onTapProfile()
    }
    
    @IBAction func btnNoticeTap(_ sender: Any) {
        delegate?.onTapNotice()
    }
    
    @IBAction func settingBtnTap(_ sender: Any) {
        delegate?.onTapSettings()
    }

    func setRightTriangle() {
        self.imgProfile.setupHexagonMask(lineWidth: 2.0, color: .green, cornerRadius: 5.0)
    }
}

extension UIBezierPath {
    convenience init(roundedPolygonPathInRect rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0) {
        self.init()

        let theta: CGFloat = 2.0 * CGFloat.pi / CGFloat(sides) // How much to turn at every corner
        let width = min(rect.size.width, rect.size.height)        // Width of the square

        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)

        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0

        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)

        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))

        for _ in 0 ..< sides {
            angle += theta

            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))

            addLine(to: start)
            addQuadCurve(to: end, controlPoint: tip)
        }

        close()
    }
}

extension UIImageView {
    func setupHexagonMask(lineWidth: CGFloat, color: UIColor, cornerRadius: CGFloat) {
        let path = UIBezierPath(roundedPolygonPathInRect: bounds, lineWidth: lineWidth, sides: 6, cornerRadius: cornerRadius, rotationOffset: CGFloat.pi / 2.0).cgPath

        let mask = CAShapeLayer()
        mask.path = path
        mask.lineWidth = lineWidth
        mask.strokeColor = UIColor.clear.cgColor
        mask.fillColor = UIColor.white.cgColor
        layer.mask = mask

        let border = CAShapeLayer()
        border.path = path
        border.lineWidth = lineWidth
        border.strokeColor = color.cgColor
        border.fillColor = UIColor.clear.cgColor
        layer.addSublayer(border)
    }
}
