//
//  ATLabel.swift
//  GeneralHomes
//
//  Created by Uma Shankar on 02/05/20.
//  Copyright © 2020 Dev-Story. All rights reserved.
//

import UIKit

@IBDesignable class ATLabel: UILabel {
    
    var edgeInsets: UIEdgeInsets {
        if autoPadding {
            if cornerRadius == 0 {
                return UIEdgeInsets.zero
            } else {
                return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
            }
        } else {
            return UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        }
    }
    
    @IBInspectable var horizontalPadding: CGFloat = 0
    @IBInspectable var verticalPadding: CGFloat = 0
    @IBInspectable var autoPadding: Bool = true
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        let edgeInsets = self.edgeInsets
        size.width += edgeInsets.left + edgeInsets.right
        size.height += edgeInsets.top + edgeInsets.bottom
        
        return size
    }
    
    @IBInspectable var lineHeight:CGFloat = 0{
        didSet{
            let text = self.text
            if let text = text {
                let attributeString = NSMutableAttributedString(string: text)
                let style = NSMutableParagraphStyle()
                
                style.lineSpacing = lineHeight
                attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
                self.attributedText = attributeString
            }
        }
    }
}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
