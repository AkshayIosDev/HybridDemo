//
//  MediaManager.swift
//  Glambar
//
//  Created by MAC on 17/08/20.
//  Copyright © 2020 Dev-Story. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices

struct MediaManager {
    // MARK: - Upload
    enum Upload {
        case photo(UIImage)
        
        
        func start(fileName:String,bucketName:String,progressClosure:((Progress)->Void)? = nil, completionHandler:@escaping ((Bool, String?)->Void)) {
            switch self {
            case .photo(let image):
                AWSManager(.photo).upload(data: image.jpegData, fileName: fileName, bucketName: bucketName, progressClosure: progressClosure, completionHandler: completionHandler)
            }
        }
    }
}

extension UIImage {
    
    /// Png data of image
    var pngData: Data? {
        return self.pngData
    }
    
    /// Jpeg data of image
    var jpegData: Data? {
        return self.jpegData(compressionQuality: 0.2)
    }
    
    /// Data of image
    var data: Data? {
        return cgImage?.dataProvider?.data as Data?
    }
}
