//
//  Global.swift
//  GeneralHomes
//
//  Created by Uma Shankar on 30/04/20.
//  Copyright © 2020 Dev-Story. All rights reserved.
//

import Foundation
import UIKit
import AVKit


let appDelegate = UIApplication.shared.delegate as! AppDelegate
var pushNotificationType = ""
//MARK: Global Alert

func showAlert(withMessage message: String? = nil, title: String = "Alert", okayTitle: String = "Ok", cancelTitle: String? = nil,viewController:UIViewController, okCall: @escaping () -> () = { }, cancelCall: @escaping () -> () = { }) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if let cancelTitle = cancelTitle {
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
            cancelCall()
        }
        cancelAction.setValue( #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1) , forKey: "titleTextColor")
        alert.addAction(cancelAction)
    }
    let okayAction = UIAlertAction(title: okayTitle, style: .default) { (_) in
        okCall()
    }
    okayAction.setValue(UIColor.AppColor, forKey: "titleTextColor")
    alert.addAction(okayAction)
    
    viewController.present(alert, animated: true)
}

func convertDateFormatter(date: String,dateFormater:String,dateFormatYouWant:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormater //this your string date format  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    dateFormatter.locale = Locale(identifier: "your_loc_id")
    let convertedDate = dateFormatter.date(from: date)
    guard dateFormatter.date(from: date) != nil else {
        return ""
    }
    dateFormatter.dateFormat = dateFormatYouWant ///this is what you want to convert format  "d MMM, yyyy h:mm a"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: convertedDate!)
    return timeStamp
}
//MARK:- Set RootViewController

//func setRootViewController(viewController: UIViewController) {
//    let navController = UINavigationController(rootViewController: viewController)
//    navController.isNavigationBarHidden = true
//   if #available(iOS 13.0, *){
//      UIApplication.shared.windows.first?.rootViewController = navController
//      UIApplication.shared.windows.first?.makeKeyAndVisible()
//   }else{
//         if appDelegate.window == nil {
//              //Create New Window here
//              appDelegate.window = UIWindow.init(frame: UIScreen.main.bounds)
//          }
//          appDelegate.window?.rootViewController = navController
//          appDelegate.window?.makeKeyAndVisible()
//   }
//}

//MARK:- move To Login RootViewController

//func moveToLoginVC() {
//    let VC: LoginVC = UIStoryboard(storyboard: .Onboarding, bundle: nil).controller()
//    setRootViewController(viewController: VC)
//}

//MARK:- move To Feed RootViewController

//func moveToFeedVC() {
//    let VC:HostFeedVC = UIStoryboard(storyboard: .Feed, bundle: nil).controller()
//    setRootViewController(viewController: VC)
//}

//MARK:- Move To Guest FeedVC With RootNavigationController

//func moveToGuestFeedVCWithRootNavigationVC(){
//    let tabBarController : TabBarController = UIStoryboard(storyboard: .Onboarding, bundle: nil).controller()
//    setRootViewController(viewController: tabBarController)
//}

//MARK:- Move To Host FeedVC With RootNavigationController

//func moveToHostFeedVCWithRootNavigationVC(){
//    let tabBarController : HostTabBarController = UIStoryboard(storyboard: .Onboarding, bundle: nil).controller()
//    setRootViewController(viewController: tabBarController)
//}

//MARK:- Move To LoginVC With RootNavigationController

//func moveToLoginVCWithRootNavigationVC(){
//    let loginVC:LoginSignupPVC = UIStoryboard(storyboard: .Onboarding, bundle: nil).controller()
//    setRootViewController(viewController: loginVC)
//}

//MARK:- Get Thumbnail Image from URL

func getThumbnailImage(forUrl url: URL) -> UIImage? {
    let asset: AVAsset = AVAsset(url: url)
    let imageGenerator = AVAssetImageGenerator(asset: asset)

    do {
        let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
        return UIImage(cgImage: thumbnailImage)
    } catch let error {
        print(error)
    }

    return nil
}

//MARK:- Check Array isNotEmpty

extension Array{
    var isNotEmpty:Bool{
        return !isEmpty
    }
}
