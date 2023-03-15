//
//  ATImageView.swift
//  GeneralHomes
//
//  Created by Dev-Story on 30/04/20.
//  Copyright © 2020 Uma Shankar. All rights reserved.
//

import UIKit
import ImageIO

@IBDesignable class ATImageView: UIImageView {
    
    private var _round = false
    private var _borderColor = UIColor.clear
    private var _borderWidth: CGFloat = 0

    @IBInspectable var cornerRadius:CGFloat = 0.0{
        didSet{
            setupCornerRadius()
        }
    }
   
   private func setupCornerRadius(){
      layer.cornerRadius =  round ? frame.height/2 : cornerRadius
   }

    @IBInspectable var round: Bool {
        set {
            _round = newValue
            makeRound()
        }
        get {
            return self._round
        }
    }

    @IBInspectable var borderColor: UIColor {
        set {
            _borderColor = newValue
            setBorderColor()
        }
        get {
            return self._borderColor
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            _borderWidth = newValue
            setBorderWidth()
        }
        get {
            return self._borderWidth
        }
    }

    override internal var frame: CGRect {
        set {
            super.frame = newValue
            makeRound()
        }
        get {
            return super.frame
        }
    }

    private func makeRound() {
        if self.round {
            self.clipsToBounds = true
            self.layer.cornerRadius = (self.frame.width + self.frame.height) / 4
        } else {
            self.layer.cornerRadius = 0
        }
    }

    private func setBorderColor() {
        self.layer.borderColor = self.borderColor.cgColor
    }
    

    private func setBorderWidth() {
        self.layer.borderWidth = self.borderWidth
    }
    
    
    @IBInspectable var shadowColor:CGColor = UIColor.black.cgColor{
        didSet{
            layer.shadowColor = shadowColor
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
    @IBInspectable var imageTintColor:UIColor?{
        didSet{
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
            self.tintColor = imageTintColor
        }
    }
}

public extension UIImage {
    var hasContent: Bool {
        return cgImage != nil || ciImage != nil
    }
}


// MARK:- Save and delete image in Local Storage


extension UIImage {
    func saveImage(ext: MediaExtension, percent: CGFloat = 0.2) -> (Bool, String, String, Int) {
        
        //FileName in string
        //
        let date = Date().toString(format: .custom("dd-MM-yyyy_HH_mm_ss"))
        let randomName = String.randomString(len: 10).appending(date).with(ext: ext)
        let fileName = "IOS_".appending(randomName)
        //
        //File Data in bytes
        //
        let fileData = ext == .png ? compressImage(percent: percent)! : self.jpegData(compressionQuality: percent)!
        //
        //File path where the file is stored on local directory
        //
        let filePath = DefaultCenter.fileManager.save(file: "\(fileName)", in: .temprary, content: fileData)
        //
        //File size in KB
        let size = fileData.count/1024
        print("Path: \(filePath), \n Size: \(size)")
        
        if DefaultCenter.fileManager.fileExists(atPath: filePath) {
            return (true, filePath, fileName, size)
        }
        
        return (false, "", "", size)
    }
    
    func compressImage(percent: CGFloat) -> Data? {
        
        var actualHeight: CGFloat = self.size.height
        var actualWidth: CGFloat = self.size.width
        let maxHeight: CGFloat = UIScreen.main.bounds.size.height * 2
        let maxWidth: CGFloat = UIScreen.main.bounds.size.height * 2
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
                
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let imageData = img.pngData() else {
            return nil
        }
        return imageData
    }
    
    func decreaseSize(percent: CGFloat = 0.6) -> UIImage {
        let data = self.jpegData(compressionQuality: percent)
        if data != nil {
            let img = UIImage.init(data: data!)
            return img != nil ? img! : self
        }
        return self
    }
    
    func length() -> Int {
        let data = self.jpegData(compressionQuality: 1.0)
        if data != nil {
            return data!.count
        }
        return 0
    }
    
    func resize(withWidth newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}



fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}


@IBDesignable class UShadowImageView: UIView {
    
    @IBInspectable var borderColor: UIColor = .black { didSet { self.layer.borderColor = self.borderColor.cgColor } }
    @IBInspectable var borderWidth: CGFloat = 0.00 { didSet { self.layer.borderWidth = self.borderWidth } }
    @IBInspectable var cornerRadius: CGFloat = 0.00 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            layoutImage()
        }
    }
    
    // ImageView Attributes
    @IBInspectable var image: UIImage? { didSet {  layoutImage() } }
    @IBInspectable var imageContentMode: UIView.ContentMode = .scaleAspectFit { didSet { layoutImage() } }
    
    // Shadow Attributes
    @IBInspectable var shadowColor: UIColor = .black { didSet { dropShadow() } }
    @IBInspectable var shadowOpacity: Float = 0.0 { didSet { dropShadow() } }
    @IBInspectable var shadowRadius: CGFloat = 0.0 { didSet { dropShadow() } }
    @IBInspectable var shadowOffset: CGSize = .zero { didSet { dropShadow() } }
    
    fileprivate var imageView = UIImageView()
    
    override func layoutSubviews() {
        layoutImage()
        dropShadow()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    fileprivate func layoutImage() {
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height)
        self.addSubview(imageView)
        imageView.image = self.image
        imageView.contentMode = self.contentMode
        imageView.layer.cornerRadius = self.layer.cornerRadius
        imageView.layer.masksToBounds = true
    }
    
    fileprivate func dropShadow() {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: cornerRadius).cgPath
    }
}
