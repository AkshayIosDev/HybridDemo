//
//  Strint+Validation.swift
//  GeneralHomes
//
//  Created by Dev-Story on 01/05/20.
//  Copyright © 2020 Uma Shankar. All rights reserved.
//

import Foundation
import UIKit
extension String {
    
    var isNotEmpty:Bool{
        return !isEmpty
    }
    
    /// This will check whether a string is empty or not by remove all spaces
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    /// This will check wheher a string is a valid email or not.
    var isEmail: Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isValidInRange(minLength min: Int = 0, maxLength max: Int) -> Bool {
        if self.count >= min && self.count <= max {
            return true
        }
        return false
    }
    
    func replace(_ string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: .literal, range: nil)
    }
    
    var trim: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    var trimmed: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    var isContainsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    //    var localized: String {
    //        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    //
    //    }
    
    var isValidZip: Bool {
        let postalcodeRegex = "^[0-9]{5}(-[0-9]{4})?|[0-9]{5}$"
        let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
        let bool = pinPredicate.evaluate(with: self) as Bool
        return bool
    }
    
    var initial: String {
        var initals = String()
        let names = self.components(separatedBy: " ")
        for name in names {
            if let firstChar = name.first {
                initals.append(firstChar)
            }
        }
        return initals
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}


extension Optional where Wrapped == String {
    var isBlank: Bool {
        guard let value = self else { return true }
        //        value = value.trimmed
        return value.isEmpty
    }
    
    var isEmail: Bool {
        guard var email = self else { return false }
        email = email.trimmed
        return email.isEmail
    }
    
    var isPhoneNumber: Bool {
        guard var phoneNumber = self else { return false }
        phoneNumber = phoneNumber.trimmed
        return phoneNumber.isPhoneNumber
    }
    
    var trimmed: String {
        guard let str = self else {
            return ""
        }
        return str.trimmed
    }
    var addTrailingAndLeadingSpace: String {
        guard let value = self else { return " " }
        return "    " + value + "   "
    }
    var isContainsWhitespace : Bool {
        guard let value = self else { return false}
        return(value.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    // Unwraps and returns the string, if nil then empty string is returned
    var unwrap: String {
        return self ?? ""
    }
}


extension String{
    // Create a random string of some length
    // - Parameter len: Total lenth of the string
    // - Returns: Random String
    static func randomString(len: Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let c = Array(charSet)
        var s: String = ""
        for _ in 1...len {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }

    // Return image name with extension of file type
    // - Parameter ext: MediaExtension
    // - Returns: String
    func with(ext: MediaExtension) -> String {
        return "\(self)\(ext.dotName)"
    }


    static func randomDateString(len: Int,isFile:Bool = false) -> String {
       let date = Date().toString(format: .custom("yyyy-MM-dd_HH:mm:ss.SSS"))
        if isFile{
            let name = "File_".appending(String.randomString(len: len)).appending(date)
            return name
        }else{
            let name = "IOS_".appending(String.randomString(len: len)).appending(date)
            return name
        }
    }




    // Encode the string into url encoded string
    // - Returns: Encoded String
    func encoding() -> String {
        let str = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if str != nil { return str! }
        return self
    }

    // Decode url encoded string into normal string
    // - Returns: String
    func decoding() -> String {
        let str = self.removingPercentEncoding
        if str != nil { return str! }
        return self
    }
}

extension String{
    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       font: UIFont = UIFont.systemFont(ofSize: 14),
                       color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                      attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
}

extension String {
    func convertDateFormatter(format:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",formatter:String = Constants.dateformat) -> String {
        let dateFormatter = DateFormatter()
        
        /// This is for all the date formatter
        
        //        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        //        dateFormatter.calendar = gregorianCalendar as Calendar
        //        dateFormatter.dateFormat = format
        
        /// This is for all the ISO 8601 format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = format
        
        let convertedDate = dateFormatter.date(from: self)
        guard dateFormatter.date(from: self) != nil else {
            return ""
        }
        
        dateFormatter.dateFormat = formatter
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.locale = Locale.current
        let timeStamp = dateFormatter.string(from: convertedDate!)
        return timeStamp
    }
}
