//
//  Uslider.swift
//  partykings
//
//  Created by Uma Shankar on 04/02/21.
//  Copyright © 2021 Dev-Story. All rights reserved.
//

import UIKit

//MARK:- IBDesignable UISlider

/// Using Uslider add thum image ---> Directly Assign Uslider to your UISlider Class Name in Storyboard 

@IBDesignable class Uslider: UISlider {
    @IBInspectable var thumbImage: UIImage?{
        didSet{
            setImage()
        }
    }
    
    func setImage(){
        if let thumbImage = thumbImage {
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
}
