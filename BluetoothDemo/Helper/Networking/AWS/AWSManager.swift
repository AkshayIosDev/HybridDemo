//
//  UploadImagesAtAWS.swift
//  Glambar
//
//  Created by MAC on 17/08/20.
//  Copyright © 2020 Dev-Story. All rights reserved.
//

import Foundation
import AWSS3

enum MediaType {
    case photo

}

struct AWSManager {
    
    // MARK: - Properties
    
    private let mediaType: MediaType
    
    init(_ mediaType: MediaType) {
        self.mediaType = mediaType
    }
    
    private var fileName: String {
        var fileExtension = ""
        switch mediaType {
        case .photo:
            fileExtension = "png"
            
            return fileExtension
        }
    }
    
    private var contentType: String {
        switch mediaType {
        case .photo:
            return "image/png"
        }
    }
    
    // MARK: - Helper
    func upload(data: Data?,fileName:String, bucketName:String,progressClosure:((Progress)->Void)? = nil, completionHandler:@escaping ((Bool, String?)->Void)) {
        guard let data = data else {
            DispatchQueue.main.async(execute: {
                completionHandler(false, nil)
            })
            return
        }
        let filePath = fileName
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                progressClosure?(progress)
            })
        }
        
        var transferCompletionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        transferCompletionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                completionHandler(error == nil, task.response?.url?.absoluteString.components(separatedBy: "?").first.unwrap)
            })
        }
        expression.setValue("public-read", forRequestParameter: "x-amz-acl")
        expression.setValue("public-read", forRequestHeader: "x-amz-acl" )
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data, bucket: bucketName, key: filePath,contentType: contentType, expression: expression, completionHandler: transferCompletionHandler)
    }
}


