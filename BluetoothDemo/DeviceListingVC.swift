//
//  DeviceListingVC.swift
//  BluetoothDemo
//
//  Created by Akshay on 29/12/22.
//

import UIKit

class DeviceListingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: "DeviceListingTVCell", bundle: nil), forCellReuseIdentifier: "DeviceListingTVCell")
        }
    }
    
    var deviceListArr:[DeviceData] = []
    var callBack:(() -> ())?
    var callBackForDisappear:(() -> ())?
    var isClear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanOnlyOnce = false
//        if Connectivity.isNotConnectedToInternet{
//            self.view.makeToast("Device Listing Showing from Local Database.", duration: 2.0, position: .center)
        for i in Defaults.user{
            if i.countAbove > 120 {
                deviceListArr.append(i)
            }
        }
            
//        }else{
//            hitDiviceListingAPI()
//        }
        
    }
   
    @IBAction func handleBackBtn(_ sender: Any) {
        if isClear{
            callBack?()
        }else{
            callBackForDisappear?()
        }
        popVC()
    }
    @IBAction func handleClear(_ sender: Any) {
        isClear = true
        Defaults.removeUserData()
        deviceListArr.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
//        hitDeleteListingAPI()
    }
    
    
    // MARK:- Respond API
    private func hitDiviceListingAPI(){
        Loader.instance.showLoader()
        let name = UserDefaults.standard.string(forKey: "Key")
        let urlEncoded = name?.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let url = "http://18.135.214.245:5000/user/getDeviceDetails?userName=\(urlEncoded!)"
        NetworkManager.hitApi(url:url, httpMethodType: .get,headerType: .none) { (response:SignupModel) in
            Loader.instance.hideLoader()
            if response.statusCode == 200{
                self.view.makeToast(response.message ?? "", duration: 2.0, position: .top)
                self.deviceListArr.append(contentsOf: response.User?.deviceData ?? [])
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                self.showErrorAlert(error: response.message ?? "")
            }
        } failure: { (error) in
            Loader.instance.hideLoader()
            self.showErrorAlert(error: error)
        }
    }
    
    private func hitDeleteListingAPI(){
        Loader.instance.showLoader()
        let name = UserDefaults.standard.string(forKey: "Key")
        let url = "http://18.135.214.245:5000/user/deleteDeviceData"
        let param:Response = ["userName":"\(name ?? "")"]
        NetworkManager.hitApi(url:url,paramaters: param, httpMethodType: .delete,headerType: .none) { (response:SignupModel) in
            Loader.instance.hideLoader()
            if response.statusCode == 200{
                self.view.makeToast(response.message ?? "", duration: 2.0, position: .top)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                self.showErrorAlert(error: response.message ?? "")
            }
        } failure: { (error) in
            Loader.instance.hideLoader()
            self.showErrorAlert(error: error)
        }
    }
}
extension DeviceListingVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deviceListArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DeviceListingTVCell = tableView.dequeueReusableCell(withIdentifier: "DeviceListingTVCell", for: indexPath) as! DeviceListingTVCell
        cell.deviceNameLbl.text = deviceListArr[indexPath.row].devicName ?? ""
        cell.macAddressLbl.text = deviceListArr[indexPath.row].identifier ?? ""
        cell.signalStrLbl.text = "\(deviceListArr[indexPath.row].averageSignalStrength ?? 0) dBm"
        cell.durationLbl.text = deviceListArr[indexPath.row].duration ?? ""
        cell.durationAboveLbl.text = deviceListArr[indexPath.row].durationAbove ?? ""
        cell.dateAndTimeLbl.text = "\(convertDateFormatter(date: deviceListArr[indexPath.row].dateAndTime ?? "", dateFormater: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", dateFormatYouWant: "yyyy-MM-dd HH:mm:ss"))"
        cell.locationLbl.text = deviceListArr[indexPath.row].locationName ?? ""
        return cell
    }
}
