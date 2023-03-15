//
//  ATErrorMessage.swift
//  BaseProject
//
//  Created by Akshay on 07/09/22.
//

import Foundation
struct ATErrorMessage {
    struct Name {
        struct First {
            static let empty = "First Name can't be empty, Please provide one."
            static let invalid = "You have not enter a valid first name, Please try with another one."
        }
        struct Middle {
            static let empty = "Middle Name can't be empty, Please provide one."
            static let invalid = "You have not enter a valid middle name, Please try with another one."
        }
        struct Last {
            static let empty = "last Name can't be empty, Please provide one."
            static let invalid = "You have not enter a valid last name, Please try with another one."
        }
        static let spacesNotAllowed = "user name not accept space."
        static let empty = "Please Provide a name."
    }
    
    struct Email {
        static let empty = "Email cant't be empty, Please provide valid email."
    }
    
    struct Password {
        static let empty = "Password cant't be empty, Please provide valid password."
    }
    
   static let URLSessionTask = "URLSessionTask failed with error:"
    
   
}
