//
//  User.swift
//  BluetoothDemo
//
//  Created by Akshay on 10/11/22.
//

import Foundation
import ObjectMapper

class SignupModel : Mappable {
    var statusCode : Int?
    var message : String?
    var User : User?

    required init?(map: Map) {}

    func mapping(map: Map) {
        statusCode <- map["statusCode"]
        message <- map["message"]
        User <- map["data"]

    }
}


class User :Codable, Mappable {
    static var userObj = User()
    var _id :String?
    var userName:String?
    var deviceData:[DeviceData]?
   
    required init?(map: Map) {}
    init() { }

    func mapping(map: Map) {
        _id <- map["_id"]
        userName <- map["userName"]
        deviceData <- map["deviceData"]
       
    }
}
class DeviceData :Codable, Mappable {
    static var userObj = DeviceData()
    
    var dateAndTime:String?
    var devicName:String?
    var identifier:String?
    var peripheralName:String?
    var signalStrength:Int?
    var averageSignalStrength:Int?
    var averageSignalArr:[Int] = []
    var duration :String?
    var durationAbove:String?
    var locationName:String?
    var mainCount = 0
    var count = 0
    var countAbove = 0
    
    
    
    var deviceActiveArr:[Int] = []
    var isDeviceActive = false
    var isDeviceDisconnect = false
    
    required init?(map: Map) {}
    init() { }

    func mapping(map: Map) {
        dateAndTime <- map["dateAndTime"]
        devicName <- map["devicName"]
        signalStrength <- map["signalStrength"]
        duration <- map["duration"]
        peripheralName <- map["peripheralName"]
        locationName <- map["location"]
        identifier <- map["identifier"]
    }
}

class DeviceLogData :Codable, Mappable {
    static var userObj = DeviceLogData()
    
    var log:String?
    
    required init?(map: Map) {}
    init() { }

    func mapping(map: Map) {
        log <- map["log"]
       
    }
}
