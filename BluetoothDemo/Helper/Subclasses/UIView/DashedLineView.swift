//
//  DashedLineView.swift
//  Mind&Mom
//
//  Created by MAC on 15/10/20.
//  Copyright © 2020 Dev-Story. All rights reserved.
//

import UIKit

@IBDesignable
class DashedLineView : UIView {
    @IBInspectable var perDashLength: CGFloat = 2.0
    @IBInspectable var spaceBetweenDash: CGFloat = 2.0
    @IBInspectable var dashColor: UIColor = UIColor.lightGray


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let  path = UIBezierPath()
        if height > width {
            let  p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: p0)

            let  p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: p1)
            path.lineWidth = width

        } else {
            let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: p0)

            let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: p1)
            path.lineWidth = height
        }

        let  dashes: [ CGFloat ] = [ perDashLength, spaceBetweenDash ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)

        path.lineCapStyle = .butt
        dashColor.set()
        path.stroke()
    }

    private var width : CGFloat {
        return self.bounds.width
    }

    private var height : CGFloat {
        return self.bounds.height
    }
}


//@IBDesignable
//public class DottedLineView: UIView {
//
//    @IBInspectable
//    public var lineColor: UIColor = UIColor.black
//    
//    @IBInspectable
//    public var lineWidth: CGFloat = CGFloat(4)
//    
//    @IBInspectable
//    public var round: Bool = false
//    
//    @IBInspectable
//    public var horizontal: Bool = true
//    
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//        initBackgroundColor()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        initBackgroundColor()
//    }
//    
//    override public func prepareForInterfaceBuilder() {
//        initBackgroundColor()
//    }
//
//    override public func draw(_ rect: CGRect) {
//
//        let path = UIBezierPath()
//        path.lineWidth = lineWidth
//
//        if round {
//            configureRoundPath(path: path, rect: rect)
//        } else {
//            configurePath(path: path, rect: rect)
//        }
//
//        lineColor.setStroke()
//        
//        path.stroke()
//    }
//
//    func initBackgroundColor() {
//        if backgroundColor == nil {
//            backgroundColor = UIColor.clear
//        }
//    }
//    
//    private func configurePath(path: UIBezierPath, rect: CGRect) {
//        if horizontal {
//            let center = rect.height * 0.5
//            let drawWidth = rect.size.width - (rect.size.width.truncatingRemainder(dividingBy: (lineWidth * 2))) + lineWidth
//            let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
//            
//            path.move(to: CGPoint(x: startPositionX, y: center))
//            path.addLine(to: CGPoint(x: drawWidth, y: center))
//            
//        } else {
//            let center = rect.width * 0.5
//            let drawHeight = rect.size.height - (rect.size.height.truncatingRemainder(dividingBy: (lineWidth * 2))) + lineWidth
//            let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
//            
//            path.move(to: CGPoint(x: center, y: startPositionY))
//            path.addLine(to: CGPoint(x: center, y: drawHeight))
//        }
//        
//        let dashes: [CGFloat] = [lineWidth, lineWidth]
//        path.setLineDash(dashes, count: dashes.count, phase: 0)
//        path.lineCapStyle = CGLineCap.butt
//    }
//    
//    private func configureRoundPath(path: UIBezierPath, rect: CGRect) {
//        if horizontal {
//            let center = rect.height * 0.5
//            let drawWidth = rect.size.width - (rect.size.width.truncatingRemainder(dividingBy: (lineWidth * 2)))
//            let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
//            
//            path.move(to: CGPoint(x: startPositionX, y: center))
//            path.addLine(to: CGPoint(x: drawWidth, y: center))
//            
//        } else {
//            let center = rect.width * 0.5
//            let drawHeight = rect.size.height - (rect.size.height.truncatingRemainder(dividingBy: (lineWidth * 2)))
//            let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
//            
//            path.move(to: CGPoint(x: center, y: startPositionY))
//            path.addLine(to: CGPoint(x: center, y: drawHeight))
//        }
//
//        let dashes: [CGFloat] = [0, lineWidth * 2]
//        path.setLineDash(dashes, count: dashes.count, phase: 0)
//        path.lineCapStyle = CGLineCap.round
//    }
//    
//}
