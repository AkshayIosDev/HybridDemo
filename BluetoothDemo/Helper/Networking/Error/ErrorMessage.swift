//
//  ErrorMessage.swift
//  GeneralHomes
//
//  Created by Dev-Story on 30/04/20.
//  Copyright © 2020 Uma Shankar. All rights reserved.
//

import Foundation
struct ErrorMessage {
    struct Server {
        static let checkConnection = "Please check your Internet connection"
        static let down = "Could not connect to server, Please check your internet connection and try again later."
        static let notFound = "The page you are looking for cannot be found. Drop us an email and let us know how you got here! You can also email us at: connect@liscio.me"
        static let corruptedResponse = "Unable to read data coming form the server."
        static let invalidKey = "Data received form server is not coming on a valid key."
    }
}
