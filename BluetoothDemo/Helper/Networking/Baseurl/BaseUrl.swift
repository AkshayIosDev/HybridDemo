//
//  BaseUrl.swift
//  GeneralHomes
//
//  Created by Dev-Story on 30/04/20.
//  Copyright © 2020 Uma Shankar. All rights reserved.
//

import Foundation
enum BaseUrl: String {

    case dev
    case prod

    var value: String {
        switch self {
        case .dev: return ""

        case .prod: return "http://198.12.224.13:3000/api/v1/" //Live Server
//      case .prod: return "http://198.12.224.13:3000/api/v1/" //Dev Server
        }
    }
}
