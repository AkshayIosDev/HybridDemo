//
//  Defaults.swift
//  PartyKings
//
//  Created by Uma Shankar on 30/05/20.
//  Copyright © 2020 Dev-Story. All rights reserved.
//

import Foundation
//
//
var userDefaults = UserDefaults.standard
//
struct Defaults {
    
    static func saveUserLogs(_ userLogs:[DeviceLogData]){
        do{
            let userLogs = try JSONEncoder.init().encode(userLogs)
            userDefaults.set(userLogs, forKey: Constants.userLogs)
            userDefaults.synchronize()
        }catch{
            print("Unable to encode user data")
        }
    }

    static var userLogs: [DeviceLogData]{
        var userLogs :[DeviceLogData] = []
        if let respLogs = userDefaults.data(forKey: Constants.userLogs){
            do{
                userLogs = try JSONDecoder.init().decode([DeviceLogData].self, from: respLogs)
            }catch{
                print("Unable to decode user data")
            }
        }
        return userLogs
    }

    static func removeUserLogsData() {
        userDefaults.removeObject(forKey: Constants.userLogs)
        userDefaults.synchronize()
    }
    
    
    static func saveUser(_ user:[DeviceData]){
        do{
            let user = try JSONEncoder.init().encode(user)
            userDefaults.set(user, forKey: Constants.user)
            userDefaults.synchronize()
        }catch{
            print("Unable to encode user data")
        }
    }

    static var user: [DeviceData]{
        var user :[DeviceData] = []
        if let resp = userDefaults.data(forKey: Constants.user){
            do{
                user = try JSONDecoder.init().decode([DeviceData].self, from: resp)
            }catch{
                print("Unable to decode user data")
            }
        }
        return user
    }

    static func removeUserData() {
        userDefaults.removeObject(forKey: Constants.user)
        userDefaults.synchronize()
    }
   
    static func saveDeviceToken(_ token:String) {
        userDefaults.set(token, forKey: Constants.deviceToken)
        userDefaults.synchronize()
    }
    
    static func removeDeviceToken() {
        userDefaults.removeObject(forKey: Constants.deviceToken)
        userDefaults.synchronize()
    }
    
    static var deviceToken:String{
        if let token = userDefaults.value(forKey: Constants.deviceToken) as? String{
            return token
        }else{
            #warning("Exclusively for development 🔥🔥🔥🔥🔥")
            return "403c5cabbadef18b114094fcb205f15033148625d295d9ab5009cc74915eee2a"
        }
    }

    static var accessToken:String{
        get{
            if let token = userDefaults.object(forKey: Constants.accessToken) as? String{
                return token
            }else{
                return ""
            }
        }
        set(newValue){
            userDefaults.set(newValue, forKey: Constants.accessToken)
            userDefaults.synchronize()
        }
    }

    static var isHost: Bool {
        get {
            if let host = userDefaults.object(forKey: "isHost")  {
                return host as! Bool
            }
            return false
        }
        set {
            userDefaults.set(newValue, forKey: "isHost")
            userDefaults.synchronize()
        }
    }
    
    static var isLogin:Bool{
        get{
            if let host = userDefaults.object(forKey:  Constants.isLogin)  {
                return host as! Bool
            }
            return false
        }
        set{
            userDefaults.set(newValue, forKey: Constants.isLogin)
            userDefaults.synchronize()
        }
    }
    
    static var lat:String{
        get{
            return userDefaults.string(forKey: ParameterKey.latitude) ?? ""
        }
        set(newValue){
            userDefaults.set(newValue, forKey:ParameterKey.latitude)
        }
    }
    
    static var long:String{
        get{
            return userDefaults.string(forKey: ParameterKey.longitude) ?? ""
        }
        set(newValue){
            userDefaults.set(newValue, forKey:ParameterKey.longitude)
        }
    }
    static var fcmToken:String{
        get{
            if let token = userDefaults.value(forKey: Constants.deviceToken) as? String{
                return token
            }else{
                #warning("Exclusively for development 🔥🔥🔥🔥🔥")
                return "403c5cabbadef18b114094fcb205f15033148625d295d9ab5009cc74915eee2a"
            }
        }
        set{
            userDefaults.set(newValue, forKey: Constants.deviceToken)
            userDefaults.synchronize()
        }
    }
}
