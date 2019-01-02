//
//  Registration.swift
//  HotelManzana
//
//  Created by Calvin Cantin on 2018-12-20.
//  Copyright © 2018 Calvin Cantin. All rights reserved.
//

import Foundation

struct Registration {
    var firstName:String
    var lastName:String
    var email:String
    
    var checkInDate:Date
    var checkOutDate:Date
    var adultNumber:Int
    var childrenNumber:Int
    
    var roomChoice:RoomType
    var wifiAcess:Bool
}
