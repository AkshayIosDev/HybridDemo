//
//  ATButton.swift
//  GeneralHomes
//
//  Created by Dev-Story on 30/04/20.
//  Copyright © 2020 Uma Shankar. All rights reserved.
//

import UIKit

import UIKit

@IBDesignable class ATButton: UIButton {
    
    @IBInspectable var cornerRadius:CGFloat = 0.0{
        didSet{
            setupCornerRadius()
        }
    }
    
    @IBInspectable var roundButton:Bool = false{
        didSet{
            setupCornerRadius()
        }
    }
    
    private func setupCornerRadius(){
        layer.cornerRadius =  roundButton ? frame.height/2 : cornerRadius
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setupButton()
    }
    
    func setupButton(){
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
    
    @IBInspectable var imageTintColor:UIColor = UIColor.black{
        didSet{
            let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
            self.setImage(tintedImage, for: .normal)
            self.tintColor = imageTintColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButton()
    }
}

extension UIButton{
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
    
    func animateBtnOnClick(){
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2.0,
          delay: 0,
          usingSpringWithDamping: 0.2,
          initialSpringVelocity: 6.0,
          options: .allowUserInteraction,
          animations: { [weak self] in
            self?.transform = .identity
          },
          completion: nil)
    }
}


@IBDesignable
class USGradientButton: ATButton {
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
