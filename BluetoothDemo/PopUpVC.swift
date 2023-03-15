//
//  PopUpVC.swift
//  BluetoothDemo
//
//  Created by Akshay on 01/12/22.
//

import UIKit

class PopUpVC: UIViewController {

    @IBOutlet weak var nameTxtFld: UITextField!
    var callBack:((_ name:String) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
//        nameTxtFld.text = "\(UIDevice.current.name)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleSaveBtn(_ sender: Any) {
        
//        self.dismissVC()
        let trimmedText = nameTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        nameTxtFld.text = trimmedText
        
        if nameTxtFld.text == ""{
            self.view.makeToast("Please enter a valid User Name.", duration: 2.0, position: .top)
        }else{
            UserDefaults.standard.set("\(self.nameTxtFld.text ?? "")", forKey: "Key") //setObject
            let name = UserDefaults.standard.string(forKey: "Key")
            print("\(name)")
            callBack?(nameTxtFld.text ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.dismissVC()
             }
           
//            hitCreateDeviceNameAPI()
        }
    }
    
    
    // MARK: - CreateDeviceName API
//    private func hitCreateDeviceNameAPI(){
////        Loader.instance.showLoader()
//        let url = "http://18.135.214.245:5000/user/create"
//        let param:Response = [ParameterKey.userName :nameTxtFld.text ?? ""]
//        NetworkManager.hitApi(url:url,paramaters: param, httpMethodType: .post,headerType: .none) { (response:SignupModel) in
////            Loader.instance.hideLoader()
//            if response.statusCode == 200{
//                self.view.makeToast(response.message ?? "", duration: 2.0, position: .top)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                    UserDefaults.standard.set("\(self.nameTxtFld.text ?? "")", forKey: "Key") //setObject
//                    self.callBack?()
//                    self.dismissVC()
//                })
//            }else{
//                self.showErrorAlert(error: response.message ?? "")
//            }
//        } failure: { (error) in
//            Loader.instance.hideLoader()
//            self.showErrorAlert(error: error)
//        }
//    }
    
}
