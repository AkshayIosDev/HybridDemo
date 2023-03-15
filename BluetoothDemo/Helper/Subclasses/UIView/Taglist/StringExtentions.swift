//
//  StringExtentions.swift
//  TaglistCollectionDemo
//
//  Created by Tejas Ardeshna on 14/12/17.
//  Copyright © 2017 Sanjaysinh Chauhan. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    static func randomImageName(length: Int) -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}


extension String {
        //Converts String to Int
        public func toInt() -> Int? {
            if let num = NumberFormatter().number(from: self) {
                return num.intValue
            } else {
                return nil
            }
        }

        //Converts String to Double
        public func toDouble() -> Double? {
            if let num = NumberFormatter().number(from: self) {
                return num.doubleValue
            } else {
                return nil
            }
        }

        /// EZSE: Converts String to Float
        public func toFloat() -> Float? {
            if let num = NumberFormatter().number(from: self) {
                return num.floatValue
            } else {
                return nil
            }
        }

        //Converts String to Bool
        public func toBool() -> Bool? {
            return (self as NSString).boolValue
        }
    }


extension Int{
    public var toString: String { return String(self) }
}
