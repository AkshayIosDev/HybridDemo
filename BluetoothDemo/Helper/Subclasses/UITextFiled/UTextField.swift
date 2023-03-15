//
//  UTextField.swift
//  Yelle
//
//  Created by Uma Shankar on 29/01/21.
//

import UIKit

@IBDesignable
class UTextField : UITextField {
    @IBInspectable var cornerRadius : CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor : UIColor? {
        didSet {
            backgroundColor = bgColor
        }
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
    
    @IBInspectable var leftPadding: CGFloat = 0{
        didSet{
            leftUpdateView()
        }
    }
    
    @IBInspectable var leftImage : UIImage? {
        didSet {
            leftUpdateView()
        }
    }
    
    @IBInspectable var leftGapPadding: CGFloat = 0{
        didSet{
            leftUpdateView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0{
        didSet{
            rightUpdateView()
        }
    }
    
    @IBInspectable var rightImage : UIImage? {
        didSet {
            rightUpdateView()
        }
    }
    
    @IBInspectable var rightGapPadding: CGFloat = 0{
        didSet{
            rightUpdateView()
        }
    }
    
    @IBInspectable var placeholderColor : UIColor? {
        didSet {
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: rawString, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor!])
            attributedPlaceholder = str
        }
    }
    
    private func leftUpdateView(){
        if let image = leftImage{
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.tintColor = tintColor
            let view = UIView(frame : CGRect(x: 0, y: 0, width: 20, height: 20))
            view.addSubview(imageView)
            leftView = view
        }else {
            leftViewMode = .never
        }
    }
    
    private func rightUpdateView(){
        if let image = rightImage{
            rightViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: rightPadding, y: 0, width: 8, height: 8)) // user your standard
            imageView.image = image
            imageView.tintColor = tintColor
            let view = UIView(frame : CGRect(x: 0, y: 0, width: 8, height: 8)) // user your standard size
            view.addSubview(imageView)
            rightView = view
        }else {
            rightViewMode = .never
        }
    }
    
    private var textPadding: UIEdgeInsets {
        let l: CGFloat = leftPadding + leftGapPadding + (leftView?.frame.width ?? 0)
        let r: CGFloat = rightPadding + rightGapPadding + (rightView?.frame.width ?? 0)
        return UIEdgeInsets(top: 0, left: l, bottom: 0, right: r)
    }
   
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: textPadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: textPadding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: textPadding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setUpUI()
    }
    
    func setUpUI(){
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpUI()
    }
}
