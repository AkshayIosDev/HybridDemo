//
//  Connectivity.swift
//  GeneralHomes
//
//  Created by Dev-Story on 30/04/20.
//  Copyright © 2020 Mac MiUma Shankar. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    static var isNotConnectedToInternet:Bool{
        return !NetworkReachabilityManager()!.isReachable
    }
}
