//
//  Constants.swift
//  MountCarmel
//
//  Created by Niraj on 07/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import Foundation
import UIKit
let APP_DELEGATE : AppDelegate = UIApplication.shared.delegate as! AppDelegate
let APP_BLUE_COLOR : UIColor = UIColor(red: 72.0/255.0, green: 186.0/255.0, blue: 248.0/255.0, alpha: 1.0)

let APP_NAME : String = "MountCarmel"
enum LoginType : String{
    case Nursery = "Nursery"
    case School = "School"
    case Parent = "Parent"
    case Staff = "STAFF"
}

let juniorBranchCodes = [12,22,23,32]
let seniorBranchCodes = [11,21,31]

 let AppEnvironment:environment = .production

enum environment{
    case development
    case production
}

struct AppDateForms {
    static let SERVER_DATE_FORMAT : String = "yyyy-MM-dd HH:mm:ss"
    
}

public struct LPKeys {
    static let DEVICE_TOKEN : String = "DEVICE_TOKEN"
    static let IS_USER_LOGGED_IN : String = "IS_USER_LOGGED_IN"
    static let LOGIN_USER_TYPE : String = "LOGIN_USER_TYPE"
    static let USER_INFO : String = "USER_INFO"
    static let LOGIN_API_RESPONSE : String = "LOGIN_API_RESPONSE"
    static let USER_ID : String = "USER_ID"
    static let USER_TOKEN : String = "USER_TOKEN"
    static let FCM_TOKEN : String = "FCM_TOKEN"
    static let USER_TOKEN_ID : String = "USER_TOKEN_ID"
    static let IMAGE_URL_PATH : String = "IMAGE_URL_PATH"
    static let PARENT_IMAGE_URL_PATH : String = "IMAGE_URL_PATH"
    static let SHOW_ENABLE_FACEID_PROMPT: String = "SHOW_ENABLE_FACEID_PROMPT"
    static let SELECTED_STUDENT : String = "SELECTED_STUDENT"
    static let STUDENT_STANDARD_SECTION : String = "STUDENT_STANDARD_SECTION"
    static let PART_STUDENT_DETAILS : String = "PART_STUDENT_DETAILS"
}

public struct DateFormat {
    static let ddMMMMyyyy           = "dd MMMM yyyy"
    static let ddMMMyyyy            = "dd MMM yyyy"
    static let ddMMyyyyhhMMSS       = "dd MMM yyyy hh:mm:ss"
    static let ddMMyyyyhhMMAM       = "yyyy-MM-dd HH:mm a"
    static let ddMMyyyy_hhMMAM       = "dd/MM/yyyy HH:mm a"
    static let ddMMhhMMAM       = "dd MMM hh:mm a"
    static let ddMMyyyyhhMM       = "yyyy-MM-dd HH:mm"
    
    static let MMyyyy               = "MM/yyyy"
    static let MMyy                 = "MM/yy"
    static let HHmmss               = "HH:mm:ss"
    static let HHmm               = "HH:mm"
    static let hhmma                = "hh:mm a"
    
    static let DateFormat_yyyyMMddhhmmss    = "yyyy-MM-dd HH:mm:ss"
    static let DateFormat_yyyyMMddThhmmssz  = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let DateFormat_ddMMYYYY = "dd/MM/yyyy"
    
    static let DateFormate_Calender = "yyyy-MM-dd hh:mm:ss ZZZZ"
    static let DateFormate_MessageServer = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let DateFormat_Message = "dd-MM-yyyy, hh:mm a"
    static let DateFormat_Message2 = "dd-MM-yyyy"
    static let DateFormat_Notice = "dd-MM-yyyy | hh:mm a"
    static let DateFormat_selfAwareness1 = "dd-MM-yyyy"
    static let DateFormat_selfAwareness2 = "hh:mm:ss"
    static let DateFormat_selfAwarenessCombine = "dd-MM-yyyy | hh:mm:ss"
    
    static let DateFormat_yyyyMMdd          = "yyyy-MM-dd"
    static let DateFormat_MMMyyyy           = "MMM-yyyy"
    static let DateFormat_DDMMYYYY           = "dd-MM-yyyy"
    static let DateFormat_MM           = "MM"
}

