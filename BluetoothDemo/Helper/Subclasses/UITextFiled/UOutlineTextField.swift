//
//  UOutlineTextField.swift
//  DemoProject
//
//  Created by Uma Shankar on 13/03/21.
//

import UIKit

 @IBDesignable open class UOutlineTextField: UITextField {
    
    public enum Step {
        case editing
        case notEditing
    }
    
    fileprivate var step : Step = .notEditing {
        didSet {
            self.animatePlaceholderIfNeeded(with: step)
        }
    }
    
    fileprivate weak var lmd_placeholder: UILabel!
    fileprivate let textRectYInset : CGFloat = 7
    fileprivate var editingConstraints = [NSLayoutConstraint]()
    fileprivate var notEditingConstraints : [NSLayoutConstraint]!
    fileprivate var activeConstraints : [NSLayoutConstraint]!
    
    //MARK: - PUBLIC VARIABLES
    public var placeholderFont = UIFont(name: FontCustom.Inter.semiBold, size: 12.0)! {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open override var text: String? {
        didSet {
            self.animatePlaceholderIfNeeded(with: self.step)
        }
    }
    
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
    
    @IBInspectable public var placeholderText: String? {
        didSet {
            self.lmd_placeholder.text = placeholderText
            self.animatePlaceholderIfNeeded(with: self.step)
        }
    }
    
    @IBInspectable public  var placeholderSizeFactor: CGFloat = 0.7  {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public  var themeColor: UIColor? = UIColor(red: 1, green: 0, blue: 131/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public  var borderColor: UIColor? = UIColor(white: 74/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public  var defaultBorderColor: UIColor? = .gray {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public  var errorBorderColor: UIColor? = UIColor(red: 1, green: 0, blue: 131/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var placeholderColor : UIColor? {
        didSet {
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: rawString, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor!])
            attributedPlaceholder = str
        }
    }
    
    @IBInspectable public var textFieldTextColor: UIColor = UIColor(white: 74/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var disabledTextColor: UIColor = UIColor(white: 183/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var disabledBackgroundColor: UIColor = UIColor(white: 247/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var enabledBackgroundColor: UIColor = .white {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var disabled = false {
        didSet {
            self.updateStep(.notEditing)
        }
    }
    
    public var error = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var topPadding: CGFloat = 6
    @IBInspectable public var leftPadding: CGFloat = 14
    
    //MARK: - LIFE CYCLE
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    fileprivate func setupViews() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        
        self.addTarget(self, action: #selector(editingDidBegin), for: UIControl.Event.editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: UIControl.Event.editingDidEnd)
        
        let placeholder = UILabel()
        
        placeholder.layoutMargins = .zero
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            placeholder.insetsLayoutMarginsFromSafeArea = false
        }
        self.addSubview(placeholder)
        
        self.lmd_placeholder = placeholder
        
        self.notEditingConstraints = [
            NSLayoutConstraint(item: self.lmd_placeholder, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: self.leftPadding),
            NSLayoutConstraint(item: self.lmd_placeholder, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(self.notEditingConstraints)
        self.activeConstraints = self.notEditingConstraints
        self.setNeedsLayout()
    }
    
    fileprivate func calculateEditingConstraints() {
        let attributedStringPlaceholder = NSAttributedString(string: (self.placeholderText ?? "").uppercased(), attributes: [
            NSAttributedString.Key.font : self.placeholderFont
            ])
        let originalWidth = attributedStringPlaceholder.boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: self.frame.height), options: [], context: nil).width
        
        let xOffset = (originalWidth - (originalWidth * placeholderSizeFactor)) / 2
        
        self.editingConstraints = [
            NSLayoutConstraint(item: self.lmd_placeholder, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: -xOffset + self.leftPadding),
            NSLayoutConstraint(item: self.lmd_placeholder, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: self.topPadding)
        ]
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.tintColor = themeColor
        self.lmd_placeholder.font = self.placeholderFont
        self.lmd_placeholder.textColor = self.placeholderColor
        self.lmd_placeholder.text = self.placeholderText?.uppercased()
        self.textColor = self.disabled ? self.disabledTextColor : self.textFieldTextColor
        self.backgroundColor = self.disabled ? self.disabledBackgroundColor : self.enabledBackgroundColor
        self.layer.borderColor = self.error ? self.errorBorderColor?.cgColor : self.step == .editing ? self.borderColor?.cgColor : self.defaultBorderColor?.cgColor
        self.isEnabled = !self.disabled
    }
    
    fileprivate func animatePlaceholderIfNeeded(with step: Step) {
        
        switch step {
        case .editing:
            self.animatePlaceholderToActivePosition()
        case .notEditing:
            if (self.text ?? "").isEmpty {
                self.animatePlaceholderToInactivePosition()
            } else {
                self.animatePlaceholderToActivePosition()
            }
        }
        self.setNeedsLayout()
    }
    
    fileprivate func animatePlaceholderToActivePosition(animated: Bool = true) {
        self.calculateEditingConstraints()
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate(self.activeConstraints)
        NSLayoutConstraint.activate(self.editingConstraints)
        self.activeConstraints = self.editingConstraints
        
        let animationBlock = {
            self.layoutIfNeeded()
            self.lmd_placeholder.transform = CGAffineTransform(scaleX: self.placeholderSizeFactor, y: self.placeholderSizeFactor)
        }
        if animated {
            UIView.animate(withDuration: 0.2) {
                animationBlock()
            }
        } else {
            animationBlock()
        }
    }
    
    fileprivate func animatePlaceholderToInactivePosition(animated: Bool = true) {
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate(self.activeConstraints)
        NSLayoutConstraint.activate(self.notEditingConstraints)
        self.activeConstraints = self.notEditingConstraints
        let animationBlock = {
            self.layoutIfNeeded()
            self.lmd_placeholder.transform = .identity
        }
        if animated {
            UIView.animate(withDuration: 0.2) {
                animationBlock()
            }
        } else {
            animationBlock()
        }
    }
    
    @objc private func editingDidBegin() {
        self.step = .editing
    }
    
    @objc private func editingDidEnd() {
        self.step = .notEditing
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        return self.calculateTextRect(forBounds: bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        return self.calculateTextRect(forBounds: bounds)
    }
    
    fileprivate func calculateTextRect(forBounds bounds: CGRect) -> CGRect {
        let textInset = (self.placeholderText ?? "").isEmpty == true ? 0 : self.textRectYInset
        return CGRect(x: leftPadding,
                      y: textInset,
                      width: bounds.width - (leftPadding * 2),
                      height: bounds.height)
    }
    
    //MARK: - PUBLIC FUNCTIONS
    public func updateStep(_ step: Step) {
        self.step = step
    }
    
}
