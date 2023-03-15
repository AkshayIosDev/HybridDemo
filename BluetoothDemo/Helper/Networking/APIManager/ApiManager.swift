//
//  ApiManager.swift
//  GeneralHomes
//
//  Created by Dev-Story on 30/04/20.
//  Copyright © 2020 Uma Shankar. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
enum DataNotFound:Error {
    case dataNotFound
}

typealias successs = (Data)-> Void
typealias failure = (Any)-> Void
typealias Response = [String:Any]

func header()->HTTPHeaders{
    return [
        "Content-Type":"application/x-www-form-urlencoded","authorization": "bearer " + Defaults.accessToken
    ]
}

func jsonHeader()->HTTPHeaders{
    return [
        "Content-Type":"application/json",
        "authorization":"Bearer " + Defaults.accessToken,
//        "timezone":getCurrentTimeZone()
    ]
}
//["Content-Type":"application/x-www-form-urlencoded", "accept":"application/json", "authorization" :""]
enum headers {
    case none
    case jsonHeader
    case urlEncodedHeader
}

func header(type : headers ) -> HTTPHeaders {
    switch type {
    case .none :
        return []
    case .jsonHeader :
        return jsonHeader()
    case .urlEncodedHeader :
        return ["Content-Type":"application/x-www-form-urlencoded","authorization": "bearer " + Defaults.accessToken]
    }
}

class NetworkManager{
    
    private init(){}
    
    static func hitApi<T:Mappable>(
        url:String,
        paramaters:Response = [:],
        httpMethodType:HTTPMethod = .post ,
        headerType:headers = .urlEncodedHeader,
        isSpecial:Bool = false,
        success:@escaping(T)-> () ,
        failure: @escaping failure)
    {
        if Connectivity.isNotConnectedToInternet{
            failure(ErrorMessage.Server.checkConnection)
        }
        
        let http = HTTPMethod(rawValue: httpMethodType.rawValue)
        
        print(" ---------- T ** Model  ---------- \n ","\(T.self)")
        print(" ---------- HTTP Method  ---------- \n",http)
        print(" ----------  URL  ---------- \n",url)
        print(" ---------- parameters  ---------- \n",paramaters)
        print(" ---------- Header  ---------- \n",headerType)
        
        if isSpecial{
            let requestUrl = URL(string: url)!
            var request = URLRequest(url: requestUrl)
            request.httpMethod = httpMethodType.rawValue
            request.allHTTPHeaderFields = ["Content-Type":"application/json", "authorization": ("bearer " + Defaults.accessToken)]
            
            do {
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: paramaters, options: [])
                request.httpBody = jsonData
            } catch {
                print(error.localizedDescription)
            }
            
            AF.request(request).responseJSON {(response) in
                NetworkManager.dataResponse(response: response) { (res:(T)) in
                    success(res)
                } failure: { (error) in
                    failure(error)
                }
            }
        }else{
            
            if httpMethodType.rawValue == "GET"{
                AF.request(url,method: .get,parameters: paramaters,encoding: URLEncoding(), headers: header(type: headerType)).responseJSON { (response) in
                    NetworkManager.dataResponse(response: response) { (res:(T)) in
                        success(res)
                    } failure: { (error) in
                        failure(error)
                    }
                }
            }
            else{
                AF.request(url, method: http, parameters: paramaters,encoding: JSONEncoding.default, headers: header(type: headerType)).responseJSON { (response) in
                    print(response.response?.statusCode as Any)
                    NetworkManager.dataResponse(response: response) { (res:(T)) in
                        success(res)
                    } failure: { (error) in
                        failure(error)
                    }
                }
            }
        }
    }
    
    static func dataResponse<T:Mappable>(response:AFDataResponse<Any>,success:@escaping(T)-> () ,failure: @escaping failure){
        print(response.response?.statusCode as Any)
        
        switch response.result{
        case .success(let value):
            guard let responseDict = value as? Response else{
                print("unable to get data")
                return
            }
            print(" ---------- responseDict  ---------- \n",responseDict)
            guard let item = Mapper<T>.init().map(JSON: responseDict) else{
                if let error = response.error{
                    failure(error)
                }
                return
            }
            print(" ---------- MODEL  ---------- \n",item)
            guard let statusCode = response.response?.statusCode,statusCode == 200 else{
                if let errorMessage = responseDict["message"] as? String{
                    failure(errorMessage)
                }
                return
            }
            
            success(item)
        case .failure(let error):
            print("error *****",error.localizedDescription)
            failure(error)
        }
    }
}

func getCurrentTimeZone() -> String{
    return TimeZone.current.identifier
}
