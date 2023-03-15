//
//  AS3Upload.swift
//  GeneralHomes
//
//  Created by Uma Shankar on 06/05/20.
//  Copyright © 2020 Dev-Story. All rights reserved.
//

import Foundation
import UIKit
import AWSS3
import AWSCore

class AS3Upload: NSObject {
    
    static let sharedInstance: AS3Upload = {
        let instance = AS3Upload()
        return instance
    }()
   
    /// upload a file to AWS S3 bucket.
    ///
    /// - Parameters:
    ///   - file: AWSS3File Modal of inputs
    ///   - completion: success: Bool, _ url: String, _ err: String
    func uploadFileToS3(file: AWSS3File, completion:@escaping (_ response: AWSS3Response?) -> Void) {
        
        ///
        /// Start Uploading process
        ///
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
        
        let s3BucketName = file.bucketName
        
        var url = URL.init(fileURLWithPath: file.fileURL)
        if let uurrl = file.url {
            url = uurrl
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadFile(url, bucket: s3BucketName, key: file.fileName, contentType: file.contentType, expression: expression) { (task, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("Upload failed ❌ (\(error!))")
                    completion(AWSS3Response.init(success: false, url: "", err: "Upload failed ❌ (\(error!.localizedDescription))", fileName: file.fileName))
                    return
                }
                if task.status == AWSS3TransferUtilityTransferStatusType.completed {
                    let s3URL = "https://\(s3BucketName).s3.amazonaws.com/\(task.key)"
                    print("Uploaded to:\n\(s3URL)")
                    completion(AWSS3Response.init(success: true, url: s3URL, err: "", fileName: task.key))
                    return
                } else {
                    print("Not uploaded")
                }
            }
            
        }.continueWith { (task) -> Any? in
            if let error = task.error {
                print("Upload failed ❌ (\(error))")
                completion(AWSS3Response.init(success: false, url: "", err: "Upload failed ❌ (\(error.localizedDescription))", fileName: file.fileName))
                return nil
            }
            
            if task.result != nil, task.isCompleted == true {
                
                let s3URL = "https://\(s3BucketName).s3.amazonaws.com/\(task.result!.key)"
                print("Uploading Start of : \(s3URL)")
                
            } else {
                print("Unexpected empty result.")
                
            }
            return nil
        }
    }
}

/// Modal to pass request in AWS Upload function
struct AWSS3File {
    var fileURL: String
    var fileName: String
    var ext: String
    var bucketName: String
    var contentType: String
    var url: URL?
}

/// Modal of aws s3 response
struct AWSS3Response {
    var success: Bool
    var url: String
    var err: String
    var fileName: String
}
