//
//	LoginAPIRoutesDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginAPIRoutesDetail : WSResponseData {
    
    var ID : String?
    var eMonthFrom : Int?
    var eMonthTo : Int?
    var eRouteId : LoginAPIERouteId?
   // var eRouteId : String?
    var eTransportRouteStopId : LoginAPIETransportRouteStopId?
    //var eTransportRouteStopId : String?

   var eTransportSlabId : LoginAPISlabID?
    //var eTransportSlabId : String?

    var mMonthFrom : Int?
    var mMonthTo : Int?
   // var mRouteId : String?
    var mRouteId : LoginAPIERouteId?
    var mTransportRouteStopId : LoginAPIETransportRouteStopId?
    //var mTransportRouteStopId : String?
    var mTransportSlabId : LoginAPISlabID?
   // var mTransportSlabId : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case eMonthFrom = "e_month_from"
        case eMonthTo = "e_month_to"
        case eRouteId = "e_route_id"
        case eTransportRouteStopId = "e_transport_route_stop_id"
        case eTransportSlabId = "e_transport_slab_id"
        case mMonthFrom = "m_month_from"
        case mMonthTo = "m_month_to"
        case mRouteId = "m_route_id"
        case mTransportRouteStopId = "m_transport_route_stop_id"
        case mTransportSlabId = "m_transport_slab_id"
//        case id = "_id"
//        case eMonthFrom = "e_month_from"
//        case eMonthTo = "e_month_to"
//        case eRouteId = "eveningroute"
//        case eTransportRouteStopId = "eveningstop"
//        case eTransportSlabId = "evening_slabname"
//        case mMonthFrom = "m_month_from"
//        case mMonthTo = "m_month_to"
//        case mRouteId = "morningroute"
//        case mTransportRouteStopId = "morningstop"
//        case mTransportSlabId = "morning_slabname"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(String.self, forKey: .id)
        eMonthFrom = try values.decodeIfPresent(Int.self, forKey: .eMonthFrom)
        eMonthTo = try values.decodeIfPresent(Int.self, forKey: .eMonthTo)
        eRouteId = try values.decodeIfPresent(LoginAPIERouteId.self, forKey: .eRouteId)
        eTransportRouteStopId = try values.decodeIfPresent(LoginAPIETransportRouteStopId.self, forKey: .eTransportRouteStopId)
        eTransportSlabId = try values.decodeIfPresent(LoginAPISlabID.self, forKey: .eTransportSlabId)
        mMonthFrom = try values.decodeIfPresent(Int.self, forKey: .mMonthFrom)
        mMonthTo = try values.decodeIfPresent(Int.self, forKey: .mMonthTo)
        mRouteId = try values.decodeIfPresent(LoginAPIERouteId.self, forKey: .mRouteId)
        mTransportRouteStopId = try values.decodeIfPresent(LoginAPIETransportRouteStopId.self, forKey: .mTransportRouteStopId)
        mTransportSlabId = try values.decodeIfPresent(LoginAPISlabID.self, forKey: .mTransportSlabId)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try! super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .id)
        try container.encode(eMonthFrom, forKey: .eMonthFrom)
        try container.encode(eMonthTo, forKey: .eMonthTo)
        try container.encode(eRouteId, forKey: .eRouteId)
        try container.encode(eTransportRouteStopId, forKey: .eTransportRouteStopId)
        try container.encode(eTransportSlabId, forKey: .eTransportSlabId)
        try container.encode(mMonthFrom, forKey: .mMonthFrom)
        try container.encode(mMonthTo, forKey: .mMonthTo)
        try container.encode(mRouteId, forKey: .mRouteId)
        try container.encode(mTransportRouteStopId, forKey: .mTransportRouteStopId)
        try container.encode(mTransportSlabId, forKey: .mTransportSlabId)
    }
}
