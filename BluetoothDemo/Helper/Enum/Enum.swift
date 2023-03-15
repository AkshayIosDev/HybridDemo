//
//  Enum.swift
//  GeneralHomes
//
//  Created by Dev-Story on 01/05/20.
//  Copyright © 2020 Uma Shankar. All rights reserved.
//

import Foundation
import UIKit

//MARK:Image Picker Alert
enum PickerAlertOptions {
   case camera
   case gallery
   case photoLibrabry
}


//MARK:- Validation

enum UserValidationState {
    case valid
    case invalid(String)
}

//MARK: Notification Center
enum DefaultCenter {
    static let notification = NotificationCenter.default
    static let fileManager = FileManager.default
}

//MARK:- Posted Event
enum PostedEvent:String {
    case past = "past"
    case upcoming = "upcoming"
    
    var name:String{
        return self.rawValue
    }
}


//MARK:- Media Extensions

enum MediaExtension: String {
    case png = "png"
    case jpg = "jpg"
    case jpeg = "jpeg"
    case mp4 = "mp4"
    case doc = "doc"
    case docX = "docx"
    case pdf = "pdf"
    case xls = "xls"
    
    var dotName: String {
        return ".\(self.rawValue)"
    }
    
    var name: String {
        return self.rawValue
    }
}

// MARK:-  Party Request

enum PartyRequestEnum {
    case accept
    case reject
    case group
}

public enum DateFormatType {
    
    /// The ISO8601 formatted year "yyyy" i.e. 1997
    case isoYear
    
    /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
    case isoYearMonth
    
    /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
    case isoDate
    
    /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
    case isoDateTime
    
    /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
    case isoDateTimeSec
    
    /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
    case isoDateTimeMilliSec
    
    /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
    case dotNet
    
    /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
    case rss
    
    /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
    case altRSS
    
    /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
    case httpHeader
    
    /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
    case standard
    
    /// A custom date format string
    case custom(String)
    
    var stringFormat: String {
        switch self {
        case .isoYear: return "yyyy"
        case .isoYearMonth: return "yyyy-MM"
        case .isoDate: return "yyyy-MM-dd"
        case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
        case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .dotNet: return "/Date(%d%f)/"
        case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
        case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
        case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
        case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
        case .custom(let customFormat): return customFormat
        }
    }
}

extension DateFormatType: Equatable {
    public static func == (lhs: DateFormatType, rhs: DateFormatType) -> Bool {
        switch (lhs, rhs) {
        case (.custom(let lhsString), .custom(let rhsString)):
            return lhsString == rhsString
        default:
            return lhs == rhs
        }
    }
}

/// The time zone to be used for date conversion
public enum TimeZoneType {
    case local, `default`, utc, custom(Int)
    var timeZone: TimeZone {
        switch self {
        case .local: return NSTimeZone.local
        case .default: return NSTimeZone.default
        case .utc: return TimeZone(secondsFromGMT: 0)!
        case let .custom(gmt): return TimeZone(secondsFromGMT: gmt)!
        }
    }
}

enum BackgroundQueue {
    static let fileUploading = DispatchQueue(label: "com.app.queue_file_uploading", qos: .background)
}
