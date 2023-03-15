//
//  ATView.swift
//  GeneralHomes
//
//  Created by Dev-Story on 30/04/20.
//  Copyright © 2020 Uma Shankar. All rights reserved.
//

import UIKit


@IBDesignable class ATView: UIView {
    
    @IBInspectable var cornerRadius:CGFloat = 0.0{
        didSet{
            setupCornerRadius()
        }
    }
    
    @IBInspectable var roundView:Bool = false{
        didSet{
            setupCornerRadius()
        }
    }
    
    
    private func setupCornerRadius(){
        layer.cornerRadius =  roundView ? frame.height/2 : cornerRadius
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setupUI()
    }
    
    func setupUI(){
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    
    
    @IBInspectable var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity:Float = 0.2{
        didSet{
            layer.shadowOpacity =  shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset:CGSize = .zero{
        didSet{
            layer.shadowOffset =  shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius:CGFloat = 0.5{
        didSet{
            layer.shadowRadius =  shadowRadius
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.black{
        didSet{
            layer.borderColor =  borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.1{
        didSet{
            layer.borderWidth =  borderWidth
        }
    }
    
    func setUpCornerRadius(){
        layer.cornerRadius = roundView ? frame.height/2 : cornerRadius
        clipsToBounds = true
    }
}


@IBDesignable class USView: UIView {
    var cornerRadiusValue : CGFloat = 0
    var corners : UIRectCorner = []
    
    @IBInspectable public var cornerRadius : CGFloat {
        get {
            return cornerRadiusValue
        }
        set {
            cornerRadiusValue = newValue
        }
    }
    
    @IBInspectable public var topLeft : Bool {
        get {
            return corners.contains(.topLeft)
        }
        set {
            if newValue {
                corners.insert(.topLeft)
                updateCorners()
            } else {
                if corners.contains(.topLeft) {
                    corners.remove(.topLeft)
                    updateCorners()
                }
            }
        }
    }
    
    @IBInspectable public var topRight : Bool {
        get {
            return corners.contains(.topRight)
        }
        set {
            if newValue {
                corners.insert(.topRight)
                updateCorners()
            } else {
                if corners.contains(.topRight) {
                    corners.remove(.topRight)
                    updateCorners()
                }
            }
            
        }
    }
    
    @IBInspectable public var bottomLeft : Bool {
        get {
            return corners.contains(.bottomLeft)
        }
        set {
            if newValue {
                corners.insert(.bottomLeft)
                updateCorners()
            } else {
                if corners.contains(.bottomLeft) {
                    corners.remove(.bottomLeft)
                    updateCorners()
                }
            }
            
        }
    }
    
    @IBInspectable public var bottomRight : Bool {
        get {
            return corners.contains(.bottomRight)
        }
        set {
            if newValue {
                corners.insert(.bottomRight)
                updateCorners()
            } else {
                if corners.contains(.bottomRight) {
                    corners.remove(.bottomRight)
                    updateCorners()
                }
            }
            
        }
    }
    
    @IBInspectable public var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable public var shadowOpacity:Float = 0.2{
        didSet{
            layer.shadowOpacity =  shadowOpacity
        }
    }
    
    @IBInspectable public var shadowOffset:CGSize = .zero{
        didSet{
            layer.shadowOffset =  shadowOffset
        }
    }
    
    @IBInspectable public var shadowRadius:CGFloat = 0.5{
        didSet{
            layer.shadowRadius =  shadowRadius
        }
    }
    
    func updateCorners() {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadiusValue, height: cornerRadiusValue))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setupUI()
    }
    
    func setupUI(){
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCorners()
    }
}


@IBDesignable
class USGradientView: UIView {
        let gradientLayer = CAGradientLayer()
    
        @IBInspectable
        var topGradientColor: UIColor? {
            didSet {
                setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor,roundness: roundness)
            }
        }
    
        @IBInspectable
        var bottomGradientColor: UIColor? {
            didSet {
                setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor, roundness: roundness)
            }
        }
        @IBInspectable var roundness: CGFloat = 0.0 {
            didSet{
                setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor, roundness: roundness)
            }
        }
    
        private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor? ,roundness:CGFloat) {
            if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
                gradientLayer.frame = bounds
                gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
                gradientLayer.borderColor = layer.borderColor
                gradientLayer.borderWidth = layer.borderWidth
                gradientLayer.cornerRadius = roundness
                layer.insertSublayer(gradientLayer, at: 0)
            } else {
                gradientLayer.removeFromSuperlayer()
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

}
