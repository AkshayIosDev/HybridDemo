//
//  DateExtension.swift
//  partykings
//
//  Created by Uma Shankar on 28/01/21.
//  Copyright © 2021 Dev-Story. All rights reserved.
//

import Foundation
import UIKit

extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone.current
        var components: DateComponents = calendar.dateComponents([.day,.month,.year], from: Date())
        components.calendar = calendar
        components.year = -18
        components.month = 12
        components.day = 31
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -100
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
    
    
    
    func setDate(from string: String, format: String, animated: Bool = true) {
        
        let formater = DateFormatter()
        
        formater.dateFormat = format
        formater.timeZone = TimeZone.current
        
        let date = formater.date(from: string) ?? Date()
        
        setDate(date, animated: animated)
    }
}

// MARK: - Format dates
extension Date {
    func stringFromFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func isoDateFormaterFromDate() -> String {
        var string: String
        let formatter = ISO8601DateFormatter()
        string = formatter.string(from: self)
        let GMT = TimeZone(abbreviation: "GMT")
        let options: ISO8601DateFormatter.Options = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime,.withTimeZone]
        string = ISO8601DateFormatter.string(from: self, timeZone: GMT!, formatOptions: options)
         return string
    }
    
    /// Converts the date to string based on a date format, optional timezone and optional locale.
    func toString(format: DateFormatType, timeZone: TimeZoneType = .local, locale: Locale = Locale.current) -> String {
        switch format {
        case .dotNet:
            let offset = Foundation.NSTimeZone.default.secondsFromGMT() / 3600
            let nowMillis = 1000 * self.timeIntervalSince1970
            return String(format: format.stringFormat, nowMillis, offset)
        default:
            break
        }
        let formatter = Date.cachedFormatter(format.stringFormat, timeZone: timeZone.timeZone, locale: locale)
        return formatter.string(from: self)
    }
    
    
    
    // A cached static array of DateFormatters so that thy are only created once.
    private static var cachedDateFormatters = [String: DateFormatter]()
    private static var cachedOrdinalNumberFormatter = NumberFormatter()
    
    /// Generates a cached formatter based on the specified format, timeZone and locale. Formatters are cached in a singleton array using hashkeys.
    private static func cachedFormatter(_ format: String = DateFormatType.standard.stringFormat, timeZone: Foundation.TimeZone = Foundation.TimeZone.current, locale: Locale = Locale.current) -> DateFormatter {
        let hashKey = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        if Date.cachedDateFormatters[hashKey] == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatter.isLenient = true
            Date.cachedDateFormatters[hashKey] = formatter
        }
        return Date.cachedDateFormatters[hashKey]!
    }
}
