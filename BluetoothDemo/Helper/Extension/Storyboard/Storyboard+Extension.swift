//
//  Storyboard+Extension.swift
//  GeneralHomes
//
//  Created by Uma Shankar on 02/05/20.
//  Copyright © 2020 Dev-Story. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

enum Storyboard: String {
    case Main
   
    var filename: String {
        switch self {
        default: return rawValue
        }
    }
}

extension UIViewController: StoryboardIdentifiable { }

extension UIStoryboard {
    /// The uniform place where we state all the storyboard we have in our application

    // MARK: - Convenience Initializers

    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    // MARK: - View Controller Instantiation from Generics

    func controller<T: UIViewController>() -> T {
        guard let vc = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        return vc
    }
}

extension UIViewController{
    
//    MARK:- Dismiss View controller
    
    func dismissVC(){
        self.dismiss(animated: false, completion: nil)
    }
    
//    MARK:- Pop View controller
    
    func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
   
    
//    MARK:- Show Error Alert
    
    func showErrorAlert(error:Any){
        if let errr = error as? Error{
            if errr.localizedDescription.contains(ATErrorMessage.URLSessionTask){
                let message = errr.localizedDescription.replace(ATErrorMessage.URLSessionTask, replacement:"")
                self.showErrorAlert(error: message)
            }
            return
        }else if let err = error as? String{
            if err.contains(Constants.invalidCredentials){
                showAlert(withMessage: err + Constants.loginAgain ,okayTitle:"Login",viewController: self,okCall:{
//                    moveToLoginVCWithRootNavigationVC()
                })
            } else if err.contains(Constants.missingAuthentication){
                showAlert(withMessage: err + Constants.loginAgain ,okayTitle:"Login",viewController: self,okCall:{
//                    moveToLoginVCWithRootNavigationVC()
                })
            }
            DispatchQueue.main.async {
                showAlert(withMessage: err,viewController: self)
            }
        }
    }
    
//    MARK:- Validate Email
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    //    MARK:- Open Address 
    
    func openAdressMap(address:String){
        let directionsURL = "http://maps.apple.com?daddr=\(address)"
        print(directionsURL)
        guard let url = URL(string: directionsURL.encoding()) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
