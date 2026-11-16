//
//  EditProfileModel.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 01/09/22.
//  Copyright © 2022 InventionHill. All rights reserved.
//

import Foundation


struct EditStudentDataModel:Codable{
    var name : String
    var admission_no : String
    var student_id : String
}

struct DepartmentDataModel:Codable{
    let data : [DepartmentModel]?
}
struct DepartmentModel:Codable{
    var _id : String?
    var name : String?
}

struct CityDataModel:Codable{
    let data : [CityModel]?
}

struct CityModel:Codable{
    let name : String?
    let city_code :  String?
}

struct StaffRoomDataModel:Codable{
    let data : [StaffRoomModel]?
}

struct StaffRoomModel:Codable{
    var _id : String?
    var room_no : String?
}

struct AdmissionDataModel:Codable{
    let data : AdmissionModel?
    let message : String?
    let status : Bool
}
struct AdmissionModel:Codable{
    let _id : String?
    let name : String?
    let admission_no : String?
    let siblings : [AdmissionSiblingsModel]?
}
struct AdmissionSiblingsModel:Codable{
    let sibling_id : AdmissionSiblings_id?
}
struct AdmissionSiblings_id:Codable{
    let _id : String?
    let name : String?
    let admission_no : String?
}

struct UpdateStaffDataModel:Codable{
    let message : String?
    let status : Bool
}
