//
//  ViewController.swift
//  BluetoothDemo
//
//  Created by Akshay on 12/10/22.
//

import UIKit
import CoreBluetooth
import CoreLocation
import os

weak var globalTimer : Timer?
var scanOnlyOnce = true
var isGlobalTimer = false
var counterTime = 0
var isScaningStoped = false


class ViewController: UIViewController , CLLocationManagerDelegate{
    private var locationManager:CLLocationManager?
    var centralManager: CBCentralManager!
    var backgroundTaskID: UIBackgroundTaskIdentifier? = nil
    var discoveredPeripheral: CBPeripheral?
    var transferCharacteristicCentral: CBCharacteristic?
    var writeIterationsComplete = 0
    var connectionIterationsComplete = 0
    var deviceID = ""
    var deviceName = ""
    let defaultIterations = 5     // change this value based on test usecase
    var isScanFirst = true
    var data = Data()
    var isScaningOver = false
    var is45MinuteTrue = true
    var is1HourTrue = false
    var is5MinuteTrue = false
    
    var checkfor100MeterMove = false
    var deviceLocation = ""
    var count = 0
    var peripheralManager: CBPeripheralManager!
    
    var transferCharacteristic: CBMutableCharacteristic?
    var connectedCentral: CBCentral?
    var dataToSend = Data()
    var sendDataIndex: Int = 0
    
    var isAdvertising = true
    var isDisappear = false
    var isDeviceScan = true
    
    @IBOutlet weak var textView1: UITextView!
    
    @IBOutlet weak var deviceNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var deviceCompleteOnHour:[DeviceData] = []
    var deviceLocalListArr:[DeviceData] = []
    var deviceLogsListArr:[DeviceLogData] = []
    var deviceListAllDeviceArr:[DeviceData] = []
    var deviceAllDeviceArr:[DeviceData] = []
    var deviceNameListArr:[DeviceData] = []
    var deviceNameArr:[String] = []
    var signalStrengthArr:[String] = []
    
    
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("MyNotification"), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
               //call any function
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleForgroundNotification(_:)), name: Notification.Name("forgroundNotification"), object: nil)
        }
        
        
        
        
        self.getUserLocation()
        
        globalTimer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (globalTimer) in
            print("global Timer ----> \(counterTime) Sec")
            let name = UserDefaults.standard.string(forKey: "Key")
            if name != nil {
                counterTime += 1
            }
            if name != nil {
            if counterTime % 5 == 0 {
                
                if !isScaningStoped{
                    print("❤️‍🔥")
                    //                    self.isDeviceScan = true
                    if self.isAdvertising{
                        // Perform the task on a background queue.
                        DispatchQueue.global().async {
                            // Request the task assertion and save the ID.
                            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "Perform Long Task") {
                                // End the task if time expires.
                                UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
                            }
                            self.isAdvertising = false
                            self.centralManager = CBCentralManager(delegate: self, queue: nil )
                            self.centralManager.stopScan()
                            os_log("Scanning stopped")
                            self.data.removeAll(keepingCapacity: false)
                            self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
                            self.peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [transferServiceUUID]])
                        }
                    }else{
                        self.isAdvertising = true
                        // Perform the task on a background queue.
                        DispatchQueue.global().async {
                            // Request the task assertion and save the ID.
                            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "Perform Long Task") {
                                // End the task if time expires.
                                UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
                            }
                            self.centralManager = CBCentralManager(delegate: self, queue: nil )
                            self.centralManager?.scanForPeripherals(
                                withServices: [transferServiceUUID], options: [
                                    CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)
                                ]
                            )
                        }
                    }
                }else{
                    //                    self.isDeviceScan = false
                    // Perform the task on a background queue.
                    DispatchQueue.global().async {
                        // Request the task assertion and save the ID.
                        self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "Perform Long Task") {
                            // End the task if time expires.
                            UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
                        }
                        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
                        self.peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [transferServiceUUID]])
                    }
                }
            }
        }
            if name != nil {
            if counterTime % 7 == 0 {
                print("🤍💟")
                // Perform the task on a background queue.
                DispatchQueue.global().async {
                    // Request the task assertion and save the ID.
                    self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "Perform Long Task") {
                        // End the task if time expires.
                        UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                        self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
                    }
                    print("🤍💟 Start Advetising")
                    let name = UserDefaults.standard.string(forKey: "Key")
                    //                self.centralManager = CBCentralManager(delegate: self, queue: .main)
                    self.peripheralManager?.startAdvertising([CBAdvertisementDataLocalNameKey:name ?? "",
                                                          CBAdvertisementDataServiceUUIDsKey : [transferServiceUUID]
                                                             ])
                }
            }
        }
            
            if counterTime > 5 {
                self.checkfor100MeterMove = true
            }
            if counterTime == 300 {
                if self.is5MinuteTrue{
                    let deviceLogObj = DeviceLogData()
                    let date = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                    deviceLogObj.log = "\(date) : Scaning Stoped"
                    self.deviceLogsListArr.append(deviceLogObj)
                    print("💛Scaning Stoped for 1 Hour")
                    self.scaningStop()
                    //                    self.is1HourTrue = true
                    //                    self.is45MinuteTrue = false
                    self.is5MinuteTrue = false
                    counterTime = 0
                   
                }
            }
            //                else if counterTime == 2700{
            //                if self.is45MinuteTrue{
            //                    let deviceLogObj = DeviceLogData()
            //                    let date = Date().today(format: "yyyy-MM-dd HH:mm:ss")
            //                    deviceLogObj.log = "\(date) : Scaning Stoped"
            //                    self.deviceLogsListArr.append(deviceLogObj)
            //                    print("💛Scaning Stoped for 1 hour")
            //                    self.scaningStop()
            //                    self.is45MinuteTrue = false
            //                    self.is1HourTrue = true
            //                    self.is5MinuteTrue = false
            //                    counterTime = 0
            //                 }
            //            }else if counterTime == 3600{
            //                if self.is1HourTrue{
            //                    let deviceLogObj = DeviceLogData()
            //                    let date = Date().today(format: "yyyy-MM-dd HH:mm:ss")
            //                    deviceLogObj.log = "\(date) : Scaning Started for 5 minute due to 60 minutes waiting"
            //                    self.deviceLogsListArr.append(deviceLogObj)
            //                    print("💛Scaning Started for 5 minute")
            //                    self.scaningStart()
            //                    self.is5MinuteTrue = true
            //                    self.is45MinuteTrue = false
            //                    self.is1HourTrue = false
            //                    counterTime = 0
            //                 }
            //            }
            
            
            for (i,j) in self.deviceNameListArr.enumerated(){
                
                
                
                if self.deviceNameListArr[i].averageSignalArr.count == 10 {
                    var averageStrength = 0
                    for k in self.deviceNameListArr[i].averageSignalArr{
                        averageStrength += k
                    }
                    self.deviceNameListArr[i].averageSignalStrength = averageStrength / 10
                    self.deviceNameListArr[i].averageSignalArr.removeAll()
                }
                self.deviceNameListArr[i].mainCount += 1
                print("▶️🟡\(self.deviceNameListArr[i].mainCount)")
                if !self.deviceNameListArr[i].isDeviceActive{
                    self.deviceNameListArr[i].count += 1
                }
                if !self.deviceNameListArr[i].isDeviceActive{
                    if self.deviceNameListArr[i].signalStrength ?? 0 > -85{
                        //                        if !self.isScaningOver{
                        if self.deviceNameListArr[i].signalStrength != 0{
                            self.deviceNameListArr[i].countAbove += 1
                        }
                        
                        //                        }
                    }
                }
                
                if self.deviceNameListArr[i].deviceActiveArr.count < 35{
                    print("1!!!!!!--->count \(self.deviceNameListArr[i].deviceActiveArr.count) ")
                    var j = self.deviceNameListArr[i].deviceActiveArr
                    
                    j.append(self.deviceNameListArr[i].signalStrength ?? 0)
                    
                    self.deviceNameListArr[i].deviceActiveArr = j
                    print("2!!!!!!--->count \(self.deviceNameListArr[i].deviceActiveArr.count) ")
                }
                if self.deviceNameListArr[i].deviceActiveArr.count == 35 {
                    var countActive = 0
                    for k in self.deviceNameListArr[i].deviceActiveArr{
                        if k == self.deviceNameListArr[i].signalStrength {
                            countActive += 1
                            print("\(countActive)")
                        }else{
                            self.deviceNameListArr[i].isDeviceActive = false
                        }
                    }
                    print("\(countActive)")
                    if countActive == 35 {
                        if !self.deviceNameListArr[i].isDeviceActive{
                            let deviceLogObj = DeviceLogData()
                            let date = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                            deviceLogObj.log = "\(date) :\(self.deviceNameListArr[i].devicName ?? "") Device Disconnected"
                            self.deviceLogsListArr.append(deviceLogObj)
                            self.deviceNameListArr[i].isDeviceDisconnect = true
                        }
                        //                        self.isDeviceScan = false
                        
                        self.deviceNameListArr[i].signalStrength = 0
                        self.deviceNameListArr[i].isDeviceActive = true
                        self.deviceNameListArr[i].deviceActiveArr.removeAll()
                    }else{
                        if self.deviceNameListArr[i].isDeviceDisconnect == true{
                            let deviceLogObj = DeviceLogData()
                            let date = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                            deviceLogObj.log = "\(date) :\(self.deviceNameListArr[i].devicName ?? "") Device Connected"
                            self.deviceLogsListArr.append(deviceLogObj)
                            self.deviceNameListArr[i].isDeviceDisconnect = false
                        }
                        //                        self.isDeviceScan = true
                        self.deviceNameListArr[i].deviceActiveArr.removeAll()
                    }
                }
                
                self.deviceNameListArr[i].duration = self.convertSecondsToHrMinuteSec(seconds: self.deviceNameListArr[i].count)//"\(self.deviceNameListArr[i].count) sec"
                self.deviceNameListArr[i].durationAbove = self.convertSecondsToHrMinuteSec(seconds: self.deviceNameListArr[i].countAbove)//"\(self.deviceNameListArr[i].countAbove) sec"
                if self.deviceNameListArr[i].mainCount > 3600 && self.deviceNameListArr[i].mainCount < 3605{
                    self.deviceCompleteOnHour = Defaults.user
                    Defaults.removeUserData()
                    
                    
                    //                    for (i,k) in self.deviceNameListArr.enumerated(){
                    if !self.deviceCompleteOnHour.contains(where: { $0.dateAndTime == "\(j.dateAndTime ?? "")" }) {
                        self.deviceCompleteOnHour.append(j)
                    }else{
                        self.deviceCompleteOnHour.filter({$0.dateAndTime == "\(j.dateAndTime ?? "")"}).first?.signalStrength = j.signalStrength
                        self.deviceCompleteOnHour.filter({$0.dateAndTime == "\(j.dateAndTime ?? "")"}).first?.averageSignalStrength = j.averageSignalStrength
                        self.deviceCompleteOnHour.filter({$0.dateAndTime == "\(j.dateAndTime ?? "")"}).first?.durationAbove = j.durationAbove
                        self.deviceCompleteOnHour.filter({$0.dateAndTime == "\(j.dateAndTime ?? "")"}).first?.duration = j.duration
                        
                        self.deviceCompleteOnHour.filter({$0.dateAndTime == "\(j.dateAndTime ?? "")"}).first?.count = (j.count + 6)
                        self.deviceCompleteOnHour.filter({$0.dateAndTime == "\(j.dateAndTime ?? "")"}).first?.countAbove = (j.countAbove + 6)
                        self.deviceCompleteOnHour.filter({$0.dateAndTime == "\(j.dateAndTime ?? "")"}).first?.mainCount = (j.mainCount + 6)
                        
                    }
                    Defaults.saveUser(self.deviceCompleteOnHour)
                    self.deviceNameListArr.remove(at: i)
                    break
                    //                    }
                    
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        let name = UserDefaults.standard.string(forKey: "Key")
        
        if name != nil {
            print("---->>>> in if \(name ?? "")")
            deviceNameLbl.text = "\(name ?? "")"
        }else{
            print(" ---->> in elese\(name ?? "")")
            let VC:PopUpVC = UIStoryboard(storyboard: .Main, bundle: nil).controller()
            VC.modalPresentationStyle = .overCurrentContext
            VC.modalTransitionStyle = .crossDissolve
            VC.callBack = { _ in
                self.deviceNameLbl.text = "\(UserDefaults.standard.string(forKey: "Key") ?? "")"
                print("💛Scaning Started  ")
                let deviceLogObj = DeviceLogData()
                let date = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                deviceLogObj.log = "\(date) : Scaning Started"
                self.deviceLogsListArr.append(deviceLogObj)
                self.scaningStart()
                let location = UserDefaults.standard.string(forKey: "location")
                let deviceLogObj1 = DeviceLogData()
                let date1 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                deviceLogObj1.log = "\(date1) :location \(location ?? "") "
                self.deviceLogsListArr.append(deviceLogObj1)
                
                let deviceLogObj2 = DeviceLogData()
                let date2 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                deviceLogObj2.log = "\(date2) :- lat: \(Defaults.lat) long: \(Defaults.long)"
                self.deviceLogsListArr.append(deviceLogObj2)
            }
            self.present(VC, animated: true, completion: nil)
        }
        
        if name != nil {
            //            DispatchQueue.global(qos: .background).async {
            //                self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil )
            //            self.peripheralManager!.startAdvertising([CBAdvertisementDataLocalNameKey:name ?? "",
            //                                                  CBAdvertisementDataServiceUUIDsKey : [transferServiceUUID],CBAdvertisementDataOverflowServiceUUIDsKey:[transferServiceUUID]
            //            ])
            
            // Perform the task on a background queue.
            DispatchQueue.global().async {
                // Request the task assertion and save the ID.
                self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "Perform Long Task") {
                    // End the task if time expires.
                    UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                    self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
                }
                
                // Run task synchronously.
                let name = UserDefaults.standard.string(forKey: "Key")
                self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil )
                self.peripheralManager!.startAdvertising([CBAdvertisementDataLocalNameKey:name ?? "",
                                                      CBAdvertisementDataServiceUUIDsKey : [transferServiceUUID],CBAdvertisementDataOverflowServiceUUIDsKey:[transferServiceUUID]
                                                         ])
                
            }
            
            if scanOnlyOnce{
                print("💛Scaning Started ")
                let deviceLogObj = DeviceLogData()
                let date = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                deviceLogObj.log = "\(date) : Scaning Started "
                self.deviceLogsListArr.append(deviceLogObj)
                self.scaningStart()
            }
            //            }
        }
        
        for j in Defaults.user{
            if j.mainCount < 3600 {
                
                //                let dateFormatter = DateFormatter()
                //                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                //                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //                if let date = dateFormatter.date(from: j.dateAndTime ?? "") {
                //
                //                    if date < Date() {
                //                        print("Before now")
                //                    } else {
                //                        print("After now")
                //                    }
                //                }
                deviceNameListArr.append(j)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        if name != nil {
//            performTask()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isDisappear{
            print("not disapper")
        }else{
            
            print("disapper")
            deviceAllDeviceArr = Defaults.user
            Defaults.removeUserData()
            for k in deviceNameListArr{
                if !deviceAllDeviceArr.contains(where: { $0.dateAndTime == "\(k.dateAndTime ?? "")" }) {
                    deviceAllDeviceArr.append(k)
                }else{
                    deviceAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.signalStrength = k.signalStrength
                    deviceAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.averageSignalStrength = k.averageSignalStrength
                    deviceAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.durationAbove = k.durationAbove
                    deviceAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.duration = k.duration
                    
                    deviceAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.count = (k.count + 6)
                    deviceAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.countAbove = (k.countAbove + 6)
                    deviceAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.mainCount = (k.mainCount + 6)
                }
            }
            Defaults.saveUser(deviceAllDeviceArr)
            deviceAllDeviceArr.removeAll()
            
            
        }
        
    }
    
    @IBAction func scanTapped(_ sender: Any) {
        let name = UserDefaults.standard.string(forKey: "Key")
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
        self.peripheralManager?.startAdvertising([CBAdvertisementDataLocalNameKey:name ?? "",
                                              CBAdvertisementDataServiceUUIDsKey : [transferServiceUUID]
                                                 ])
    }
    @IBAction func handleDeviceListingBtn(_ sender: Any) {
        
        //        print(deviceListAllDeviceArr[100])
        deviceListAllDeviceArr = Defaults.user
        Defaults.removeUserData()
        for k in deviceNameListArr{
            if !deviceListAllDeviceArr.contains(where: { $0.dateAndTime == "\(k.dateAndTime ?? "")" }) {
                deviceListAllDeviceArr.append(k)
            }else{
                deviceListAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.signalStrength = k.signalStrength
                deviceListAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.averageSignalStrength = k.averageSignalStrength
                deviceListAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.durationAbove = k.durationAbove
                deviceListAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.duration = k.duration
                
                deviceListAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.count = (k.count + 6)
                deviceListAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.countAbove = (k.countAbove + 6)
                deviceListAllDeviceArr.filter({$0.dateAndTime == "\(k.dateAndTime ?? "")"}).first?.mainCount = (k.mainCount + 6)
            }
        }
        Defaults.saveUser(deviceListAllDeviceArr)
        deviceListAllDeviceArr.removeAll()
        let vc:DeviceListingVC = UIStoryboard(storyboard: .Main, bundle: nil).controller()
        vc.callBack = {
            self.deviceLocalListArr.removeAll()
        }
        vc.callBackForDisappear = {
            self.isDisappear = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logsBtnTapped(_ sender: Any) {
        var a = Defaults.userLogs
        
        for i in deviceLogsListArr{
            if !a.contains(where: { $0.log == "\(i.log ?? "")" }) {
                a.append(i)
            }
        }
        Defaults.saveUserLogs(a)
        let vc:LogsVC = UIStoryboard(storyboard: .Main, bundle: nil).controller()
        
        vc.callBack = {
            self.deviceLogsListArr.removeAll()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        print("\(#function) called before going to background")
        self.is5MinuteTrue = true
        counterTime = 0
        print("counter time \(counterTime)")
        let deviceLogObj = DeviceLogData()
        let date = Date().today(format: "yyyy-MM-dd HH:mm:ss")
        deviceLogObj.log = "\(date) : Scaning Started for 5 minute Due to minimised"
        self.deviceLogsListArr.append(deviceLogObj)
        self.scaningStop()
        self.scaningStart()
    }
    @objc func handleForgroundNotification(_ notification: Notification) {
        print("\(#function) called  forground")
        self.is5MinuteTrue = false
        print("counter time \(counterTime)")
        let deviceLogObj = DeviceLogData()
        let date = Date().today(format: "yyyy-MM-dd HH:mm:ss")
        deviceLogObj.log = "\(date) : Scaning Started Due to Foreground"
        self.deviceLogsListArr.append(deviceLogObj)
        self.scaningStop()
        self.scaningStart()
        
    }
   
    deinit {
            // Unregister the observer
               NotificationCenter.default.removeObserver(self, name: Notification.Name("MyNotification"), object: nil)
               NotificationCenter.default.removeObserver(self, name: Notification.Name("forgroundNotification"), object: nil)
        }
    func scaningStart(){
        print("Scanning started")
        // All we advertise is our service's UUID
        //call any function
        // All we advertise is our service's UUID
        isScanFirst = true
        isScaningStoped = false
        
        // Start up the CBPeripheralManager
        DispatchQueue.global(qos: .background).async {
            self.centralManager = CBCentralManager(delegate: self, queue: nil )
            self.centralManager?.scanForPeripherals(
                withServices: [transferServiceUUID], options: [
                    CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)
                ]
            )
        }
    }
    func scaningStop(){
        print("Enters in Scaning Stop")
        //        self.activityIndicator.isHidden = true
        self.centralManager?.stopScan()
        isScaningStoped = true
        //        self.timer.invalidate()
    }
    
    
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy =  kCLLocationAccuracyNearestTenMeters
        locationManager?.distanceFilter = 150
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)")
            //                if  Defaults.lat  == ""{
            //                    Defaults.lat = "\(location.coordinate.latitude)"
            //                    Defaults.long = "\(location.coordinate.longitude)"
            //                }else{
            Defaults.lat = "\(location.coordinate.latitude)"
            Defaults.long = "\(location.coordinate.longitude)"
            let location = CLLocation(latitude: Double(Defaults.lat) ?? 0.0, longitude: Double(Defaults.long) ?? 0.0)
            location.fetchCityAndCountry { locality,city, country, error in
                guard let locality = locality, let city = city, let country = country, error == nil else { return }
                print(city + ", " + country)  // Rio de Janeiro, Brazil
                self.deviceLocation = "\(locality), \(city), \(country)"
                UserDefaults.standard.set("\(self.deviceLocation)", forKey: "location")
            }
            
            //                    let cordinate1 = CLLocation(latitude: Double(Defaults.lat) ?? 0.0, longitude: Double(Defaults.long) ?? 0.0)
            //                    let coordinate2 = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //                    let d:Double = cordinate1.distance(from: coordinate2)
            //                    print("*******\(d)m")
            //                    let a =  Int(d)//.rounded(toPlaces: 0)
            //                    print("------rounded\(a)")
            //                    print("&&&&&&\(d/1000.0)km")
            //                    if a >= 100{
            //                        if isInBackground{
            //                            print("InBackground")
            //                        }else{
            //                            print("else")
            //                if location.courseAccuracy > 10 {
            //                    let deviceLogObj4 = DeviceLogData()
            //                    let date4 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
            //                    deviceLogObj4.log = "\(date4) : locaion ignore due to accuracy "
            //                    self.deviceLogsListArr.append(deviceLogObj4)
            //                }
            //                else{
            if checkfor100MeterMove{
                if location.horizontalAccuracy <= 10 {
                    print("💛Scaning Stop Due to 150 meter move ")
//                    let deviceLogObj1 = DeviceLogData()
//                    let date1 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
//                    deviceLogObj1.log = "\(date1) : Scanning started  Due to 150 meter move"
//                    self.deviceLogsListArr.append(deviceLogObj1)
                    
                    
                    let deviceLogObj2 = DeviceLogData()
                    let date2 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                    deviceLogObj2.log = "\(date2) :Lat :\(location.coordinate.latitude) \nLng :\(location.coordinate.longitude)"
                    self.deviceLogsListArr.append(deviceLogObj2)
                    if location.courseAccuracy > 0{
                        let deviceLogObj3 = DeviceLogData()
                        let date3 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                        deviceLogObj3.log = "\(date3) : accuracy \(location.courseAccuracy)"
                        self.deviceLogsListArr.append(deviceLogObj3)
                    }
                    let deviceLogObj4 = DeviceLogData()
                    let date4 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                    deviceLogObj4.log = "\(date4) : location \(self.deviceLocation)"
                    self.deviceLogsListArr.append(deviceLogObj4)
                    print("💛Timer Reset")
                    
                    print("💛Scaning Started due to 150 meter move")
                    let name = UserDefaults.standard.string(forKey: "Key")
                    if name != nil {
//                    self.scaningStop()
//                    counterTime = 0
//                    is45MinuteTrue = true
//                    is1HourTrue = false
//                    is5MinuteTrue = false
//
//                    self.scaningStart()
                    }
                }else{
                    let deviceLogObj1 = DeviceLogData()
                    let date1 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                    deviceLogObj1.log = "\(date1) : Location ignore due  inAccuracy"
                    self.deviceLogsListArr.append(deviceLogObj1)
                    return
                }
            }
            //                }
        }
    }
    //                }
    //            }
    //        }
    func convertSecondsToHrMinuteSec(seconds:Int) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        
        let formattedString = formatter.string(from:TimeInterval(seconds))!
        print(formattedString)
        return formattedString
    }
    
    func performTask()
    {
        // Perform the task on a background queue.
        DispatchQueue.global().async {
            // Request the task assertion and save the ID.
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "Perform Long Task") {
                // End the task if time expires.
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
            
            // Run task synchronously.
            let name = UserDefaults.standard.string(forKey: "Key")
            self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil )
            self.peripheralManager!.startAdvertising([CBAdvertisementDataLocalNameKey:name ?? "",
                                                  CBAdvertisementDataServiceUUIDsKey : [transferServiceUUID],CBAdvertisementDataOverflowServiceUUIDsKey:[transferServiceUUID]
                                                     ])
            
            // End the task assertion.
            //          UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            //           self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    // MARK: - Helper Methods
    
    /*
     * We will first check if we are already connected to our counterpart
     * Otherwise, scan for peripherals - specifically for our service's 128bit CBUUID
     */
    private func retrievePeripheral() {
        
        let connectedPeripherals: [CBPeripheral] = (centralManager.retrieveConnectedPeripherals(withServices: [transferServiceUUID]))
        
        os_log("Found connected Peripherals with transfer service: %@", connectedPeripherals)
        
        if let connectedPeripheral = connectedPeripherals.last {
            os_log("Connecting to peripheral %@", connectedPeripheral)
            self.discoveredPeripheral = connectedPeripheral
            centralManager.connect(connectedPeripheral, options: nil)
        } else {
            // We were not connected to our counterpart, so start scanning
            centralManager.scanForPeripherals(withServices: [transferServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    /*
     *  Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    private func cleanup() {
        // Don't do anything if we're not connected
        guard let discoveredPeripheral = discoveredPeripheral,
              case .connected = discoveredPeripheral.state else { return }
        
        for service in (discoveredPeripheral.services ?? [] as [CBService]) {
            for characteristic in (service.characteristics ?? [] as [CBCharacteristic]) {
                if characteristic.uuid == transferCharacteristicUUID && characteristic.isNotifying {
                    // It is notifying, so unsubscribe
                    self.discoveredPeripheral?.setNotifyValue(false, for: characteristic)
                }
            }
        }
        
        // If we've gotten this far, we're connected, but we're not subscribed, so we just disconnect
        centralManager.cancelPeripheralConnection(discoveredPeripheral)
    }
    
    /*
     *  Write some test data to peripheral
     */
    private func writeData() {
        
        guard let discoveredPeripheral = discoveredPeripheral,
              let transferCharacteristic = transferCharacteristicCentral
        else { return }
        
        // check to see if number of iterations completed and peripheral can accept more data
        while writeIterationsComplete < defaultIterations && discoveredPeripheral.canSendWriteWithoutResponse {
            
            let mtu = discoveredPeripheral.maximumWriteValueLength (for: .withoutResponse)
            var rawPacket = [UInt8]()
            
            let bytesToCopy: size_t = min(mtu, data.count)
            data.copyBytes(to: &rawPacket, count: bytesToCopy)
            let packetData = Data(bytes: &rawPacket, count: bytesToCopy)
            
            let stringFromData = String(data: packetData, encoding: .utf8)
            //            os_log("Writing %d bytes: %s", bytesToCopy, String(describing: stringFromData))
            
            discoveredPeripheral.writeValue(packetData, for: transferCharacteristic, type: .withoutResponse)
            
            writeIterationsComplete += 1
            
        }
        
        if writeIterationsComplete == defaultIterations {
            // Cancel our subscription to the characteristic
            discoveredPeripheral.setNotifyValue(false, for: transferCharacteristic)
        }
    }
    
    
    
    // MARK: - Helper Methods
    
    /*
     *  Sends the next amount of data to the connected central
     */
    static var sendingEOM = false
    
    private func sendData() {
        
        guard let transferCharacteristic = transferCharacteristic else {
            return
        }
        
        // First up, check if we're meant to be sending an EOM
        if ViewController.sendingEOM {
            // send it
            let didSend = peripheralManager.updateValue("EOM".data(using: .utf8)!, for: transferCharacteristic, onSubscribedCentrals: nil)
            // Did it send?
            if didSend {
                // It did, so mark it as sent
                ViewController.sendingEOM = false
                os_log("Sent: EOM")
            }
            // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
            return
        }
        
        // We're not sending an EOM, so we're sending data
        // Is there any left to send?
        if sendDataIndex >= dataToSend.count {
            // No data left.  Do nothing
            return
        }
        
        // There's data left, so send until the callback fails, or we're done.
        var didSend = true
        while didSend {
            
            // Work out how big it should be
            var amountToSend = dataToSend.count - sendDataIndex
            if let mtu = connectedCentral?.maximumUpdateValueLength {
                amountToSend = min(amountToSend, mtu)
            }
            
            // Copy out the data we want
            let chunk = dataToSend.subdata(in: sendDataIndex..<(sendDataIndex + amountToSend))
            
            // Send it
            didSend = peripheralManager.updateValue(chunk, for: transferCharacteristic, onSubscribedCentrals: nil)
            
            // If it didn't work, drop out and wait for the callback
            if !didSend {
                return
            }
            
            let stringFromData = String(data: chunk, encoding: .utf8)
            os_log("Sent %d bytes: %s", chunk.count, String(describing: stringFromData))
            
            // It did send, so update our index
            sendDataIndex += amountToSend
            // Was it the last one?
            if sendDataIndex >= dataToSend.count {
                // It was - send an EOM
                
                // Set this so if the send fails, we'll send it next time
                ViewController.sendingEOM = true
                
                //Send it
                let eomSent = peripheralManager.updateValue("EOM".data(using: .utf8)!,
                                                            for: transferCharacteristic, onSubscribedCentrals: nil)
                
                if eomSent {
                    // It sent; we're all done
                    ViewController.sendingEOM = false
                    os_log("Sent: EOM")
                }
                return
            }
        }
    }
    
    private func setupPeripheral() {
        
        // Build our service.
        
        // Start with the CBMutableCharacteristic.
        let transferCharacteristic = CBMutableCharacteristic(type: transferCharacteristicUUID,
                                                             properties: [.notify, .writeWithoutResponse],
                                                             value: nil,
                                                             permissions: [.readable, .writeable])
        
        // Create a service from the characteristic.
        let transferService = CBMutableService(type: transferServiceUUID, primary: true)
        
        // Add the characteristic to the service.
        transferService.characteristics = [transferCharacteristic]
        
        // And add it to the peripheral manager.
        peripheralManager.add(transferService)
        
        // Save the characteristic for later.
        self.transferCharacteristic = transferCharacteristic
        
    }
    
}

extension ViewController: CBCentralManagerDelegate {
    // implementations of the CBCentralManagerDelegate methods
    
    /*
     *  centralManagerDidUpdateState is a required protocol method.
     *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
     *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
     *  the Central is ready to be used.
     */
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            // ... so start working with the peripheral
            os_log("CBManager is powered on")
            retrievePeripheral()
        case .poweredOff:
            os_log("CBManager is not powered on")
            // In a real app, you'd deal with all the states accordingly
            return
        case .resetting:
            os_log("CBManager is resetting")
            // In a real app, you'd deal with all the states accordingly
            return
        case .unauthorized:
            // In a real app, you'd deal with all the states accordingly
            if #available(iOS 13.0, *) {
                switch central.authorization {
                case .denied:
                    os_log("You are not authorized to use Bluetooth")
                case .restricted:
                    os_log("Bluetooth is restricted")
                default:
                    os_log("Unexpected authorization")
                }
            } else {
                // Fallback on earlier versions
            }
            return
        case .unknown:
            os_log("CBManager state is unknown")
            // In a real app, you'd deal with all the states accordingly
            return
        case .unsupported:
            os_log("Bluetooth is not supported on this device")
            // In a real app, you'd deal with all the states accordingly
            return
        @unknown default:
            os_log("A previously unknown central manager state occurred")
            // In a real app, you'd deal with yet unknown cases that might occur in the future
            return
        }
    }
    
    /*
     *  This callback comes whenever a peripheral that is advertising the transfer serviceUUID is discovered.
     *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
     *  we start the connection process
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        // Reject any where the value is above reasonable range
        // Reject if the signal strength is too low to be close enough (Close is around -22dB)
        
        //        if  RSSI.integerValue < -15 && RSSI.integerValue > -35 {
        //            println("Device not at correct range")
        //            return
        //        }
        
        //let uniqueID = (advertisementData["\(transferCharacteristicUUID)"] as! NSArray).firstObject!
        // print("-----====---->\(uniqueID)")
        // Ok, it's in range - have we already seen it?
        
        if discoveredPeripheral != peripheral {
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            discoveredPeripheral = peripheral
            
            // And connect
            print("Connecting to peripheral \(peripheral)")
            
            centralManager?.connect(peripheral, options: nil)
            //            centralManager?.cancelPeripheralConnection(peripheral)
        }
        
       
        
        deviceNameListArr.filter({$0.identifier == "\(peripheral.identifier)"}).first?.signalStrength = RSSI.intValue
        
        if let index = deviceNameListArr.firstIndex(where: {$0.identifier == "\(peripheral.identifier)"}){
            
            print("\(index)===== \(self.deviceNameListArr.count)")
            
            print("===== \(deviceNameListArr[index].averageSignalArr.count)")
            
            
            if deviceNameListArr[index].averageSignalArr.count < 10{
                var j = deviceNameListArr[index].averageSignalArr
                
                j.append(RSSI.intValue)
                
                deviceNameListArr[index].averageSignalArr = j
                print("=====> \(deviceNameListArr[index].averageSignalArr.count)")
            }
        }
        
        if peripheral.name == nil {return}
        if peripheral.name == "" {return}
        let subString = ( peripheral.name! as NSString).contains("iPhone")
        if(subString)
        {
            print("Exist")
            return
        }
        print("Discovered \(peripheral.name ?? "") at \(RSSI)")
        if !deviceNameListArr.contains(where: { $0.devicName == "\(peripheral.name ?? "")" }) {
//                isScanInOneHour = true
            let deviceLogObj = DeviceLogData()
            let date1 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
            deviceLogObj.log = "\(date1) : New Device Connected :\(peripheral.name ?? "")"
            self.deviceLogsListArr.append(deviceLogObj)
            
            
                let deviceNameListObj = DeviceData()
                deviceNameListObj.identifier = "\(peripheral.identifier)"
                deviceNameListObj.peripheralName = "\(peripheral.name ?? "")"
//                if uniqueID == nil{
//                    deviceNameListObj.devicName = "\(peripheral.name ?? "")"//deviceName
//                }else{
                    deviceNameListObj.devicName = "\(peripheral.name ?? "")"//deviceName
//                }
                
                deviceNameListObj.signalStrength = RSSI.intValue
                deviceNameListObj.averageSignalStrength = RSSI.intValue
                deviceNameListObj.count = 0
                let date = Date().today(format: "yyyy-MM-dd'T'HH:mm:ss.SSS")
                print(date)
                
                deviceNameListObj.dateAndTime = "\(date)"
                
                if deviceLocation == ""{
                    let locatin = UserDefaults.standard.string(forKey: "location")
                    deviceNameListObj.locationName = "\(locatin ?? "")"
                }else{
                    deviceNameListObj.locationName = deviceLocation
                }
                
                deviceNameListObj.duration = "\(count) Sec"
                
                deviceNameListArr.append(deviceNameListObj)
                isGlobalTimer = true
        }
//        }

        deviceNameListArr.filter({$0.devicName == "\(peripheral.name ?? "")"}).first?.signalStrength = RSSI.intValue
        
            if let index = deviceNameListArr.firstIndex(where: {$0.devicName == "\(peripheral.name ?? "")"}){
               
                print("\(index)===== \(self.deviceNameListArr.count)")
                
                print("===== \(deviceNameListArr[index].averageSignalArr.count)")
               
                
                if deviceNameListArr[index].averageSignalArr.count < 10{
                    var j = deviceNameListArr[index].averageSignalArr
                   
                    j.append(RSSI.intValue)

                    deviceNameListArr[index].averageSignalArr = j
                    print("=====> \(deviceNameListArr[index].averageSignalArr.count)")
                }
            }

        print("Discovered \(peripheral.name ?? "") at \(RSSI)")
        
    }
    
    /*
     *  If the connection fails for whatever reason, we need to deal with it.
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        os_log("Failed to connect to %@. %s", peripheral, String(describing: error))
        cleanup()
    }
    
    /*
     *  We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        os_log("Peripheral Connected")
        
        // Stop scanning
        centralManager.stopScan()
        os_log("Scanning stopped")
        
        // set iteration info
        connectionIterationsComplete += 1
        writeIterationsComplete = 0
        
        // Clear the data that we may already have
        data.removeAll(keepingCapacity: false)
        
        // Make sure we get the discovery callbacks
        peripheral.delegate = self
        
        // Search only for services that match our UUID
        peripheral.discoverServices([transferServiceUUID])
    }
    
    /*
     *  Once the disconnection happens, we need to clean up our local copy of the peripheral
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        os_log("Perhiperal Disconnected")
        discoveredPeripheral = nil
        
        // We're disconnected, so start scanning again
        if connectionIterationsComplete < defaultIterations {
            retrievePeripheral()
        } else {
            os_log("Connection iterations completed")
        }
    }
    
}

extension ViewController: CBPeripheralDelegate {
    // implementations of the CBPeripheralDelegate methods
    
    /*
     *  The peripheral letting us know when services have been invalidated.
     */
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
        for service in invalidatedServices where service.uuid == transferServiceUUID {
            os_log("Transfer service is invalidated - rediscover services")
            peripheral.discoverServices([transferServiceUUID])
        }
    }
    
    /*
     *  The Transfer Service was discovered
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            os_log("Error discovering services: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        // Discover the characteristic we want...
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            peripheral.discoverCharacteristics([transferCharacteristicUUID], for: service)
        }
    }
    
    /*
     *  The Transfer characteristic was discovered.
     *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any).
        if let error = error {
            os_log("Error discovering characteristics: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        // Again, we loop through the array, just in case and check if it's the right one
        guard let serviceCharacteristics = service.characteristics else { return }
        for characteristic in serviceCharacteristics where characteristic.uuid == transferCharacteristicUUID {
            // If it is, subscribe to it
            transferCharacteristicCentral = characteristic
            peripheral.setNotifyValue(true, for: characteristic)
        }
        
        // Once this is complete, we just need to wait for the data to come in.
    }
    
    /*
     *   This callback lets us know more data has arrived via notification on the characteristic
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // Deal with errors (if any)
        if let error = error {
            os_log("Error discovering characteristics: %s", error.localizedDescription)
            cleanup()
            return
        }
        
        guard let characteristicData = characteristic.value,
              let stringFromData = String(data: characteristicData, encoding: .utf8) else { return }
        
        os_log("Received %d bytes: %s", characteristicData.count, stringFromData)
        
        // Have we received the end-of-message token?
        if stringFromData == "EOM" {
            // End-of-message case: show the data.
            // Dispatch the text view update to the main queue for updating the UI, because
            // we don't know which thread this method will be called back on.
            DispatchQueue.main.async() {
                let string = String(data: self.data, encoding: .utf8)
                let replaced = (string as NSString?)?.replacingOccurrences(of: "'", with: "\"")
                let data = replaced?.data(using: .utf8)!
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [Dictionary<String,Any>]
                    {
                        print(jsonArray) // use the json here
                        for obj in jsonArray {
                            if let dict = obj as? NSDictionary {
                                // Now reference the data you need using:
                                let id = dict.value(forKey: "id")
                                let message = dict.value(forKey: "message")
                                print("-------->>>>\(id ?? "")")
                                self.deviceID = "\(id ?? "")"
                                print("------>>>>\(message ?? "")")
                                self.deviceName = "\(message ?? "")"
                                
                                
                                
                                if self.deviceID == "bluetoothDetectDeom"{
                                    
                                    if !self.deviceNameListArr.contains(where: { $0.devicName == "\(self.deviceName)" }) {
                                        let deviceLogObj = DeviceLogData()
                                        let date1 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                                        deviceLogObj.log = "\(date1) : New Device Connected :\(self.deviceName)"
                                        self.deviceLogsListArr.append(deviceLogObj)
                                        
                                        
                                        let deviceNameListObj = DeviceData()
                                        deviceNameListObj.identifier = "\(peripheral.identifier)"
                                        deviceNameListObj.peripheralName = "\(peripheral.name ?? "")"
                                        //                if uniqueID == nil{
                                        //                    deviceNameListObj.devicName = "\(peripheral.name ?? "")"//deviceName
                                        //                }else{
                                        deviceNameListObj.devicName = "\(self.deviceName)"//deviceName
                                        //                }
                                        
                                        deviceNameListObj.signalStrength = -32
                                        deviceNameListObj.averageSignalStrength = -30
                                        deviceNameListObj.count = 0
                                        let date = Date().today(format: "yyyy-MM-dd'T'HH:mm:ss.SSS")
                                        print(date)
                                        
                                        deviceNameListObj.dateAndTime = "\(date)"
                                        
                                        if self.deviceLocation == ""{
                                            let locatin = UserDefaults.standard.string(forKey: "location")
                                            deviceNameListObj.locationName = "\(locatin ?? "")"
                                        }else{
                                            deviceNameListObj.locationName = self.deviceLocation
                                        }
                                        
                                        deviceNameListObj.duration = "\(self.count) Sec"
                                        
                                        self.deviceNameListArr.append(deviceNameListObj)
                                        isGlobalTimer = true
                                    }
                                    if self.deviceNameListArr.contains(where: { $0.devicName == "\(self.deviceName)" }) {
                                        if !self.deviceNameListArr.contains(where: { $0.identifier == "\(peripheral.identifier)" }) {
                                            self.deviceNameListArr.filter({$0.devicName == "\(self.deviceName)"}).first?.identifier = "\(peripheral.identifier)"
                                            let deviceLogObj2 = DeviceLogData()
                                            let date2 = Date().today(format: "yyyy-MM-dd HH:mm:ss")
                                            deviceLogObj2.log = "\(date2) :Connected and Mac Address Updated For:\(self.deviceName)"
                                            self.deviceLogsListArr.append(deviceLogObj2)
                                        }
                                    }
                                }
                                
                                
                                
                                
                            }
                        }
                        //                    DispatchQueue.main.async {
                        //                        self.tableView.layoutIfNeeded()
                        //                        self.tableView.reloadData()
                        ////                        self.tableView.scrollToBottom()
                        //                    }
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
                
                
                
                // Cancel our subscription to the characteristic
                peripheral.setNotifyValue(false, for: characteristic)
                
                // and disconnect from the peripehral
                self.centralManager?.cancelPeripheralConnection(peripheral)
            }
            
            // Write test data
            writeData()
        } else {
            // Otherwise, just append the data to what we have previously received.
            data.append(characteristicData)
        }
    }
    
    /*
     *  The peripheral letting us know whether our subscribe/unsubscribe happened or not
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        // Deal with errors (if any)
        if let error = error {
            os_log("Error changing notification state: %s", error.localizedDescription)
            return
        }
        
        // Exit if it's not the transfer characteristic
        guard characteristic.uuid == transferCharacteristicUUID else { return }
        
        if characteristic.isNotifying {
            // Notification has started
            os_log("Notification began on %@", characteristic)
        } else {
            // Notification has stopped, so disconnect from the peripheral
            os_log("Notification stopped on %@. Disconnecting", characteristic)
            cleanup()
        }
        
    }
    
    /*
     *  This is called when peripheral is ready to accept more data when using write without response
     */
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        os_log("Peripheral is ready, send data")
        writeData()
    }
    
}

extension ViewController: CBPeripheralManagerDelegate {
    // implementations of the CBPeripheralManagerDelegate methods
    
    /*
     *  Required protocol method.  A full app should take care of all the possible states,
     *  but we're just waiting for to know when the CBPeripheralManager is ready
     *
     *  Starting from iOS 13.0, if the state is CBManagerStateUnauthorized, you
     *  are also required to check for the authorization state of the peripheral to ensure that
     *  your app is allowed to use bluetooth
     */
    internal func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        //        advertisingSwitch.isEnabled = peripheral.state == .poweredOn
        
        switch peripheral.state {
        case .poweredOn:
            // ... so start working with the peripheral
            os_log("CBManager is powered on")
            setupPeripheral()
        case .poweredOff:
            os_log("CBManager is not powered on")
            // In a real app, you'd deal with all the states accordingly
            return
        case .resetting:
            os_log("CBManager is resetting")
            // In a real app, you'd deal with all the states accordingly
            return
        case .unauthorized:
            // In a real app, you'd deal with all the states accordingly
            if #available(iOS 13.0, *) {
                switch peripheral.authorization {
                case .denied:
                    os_log("You are not authorized to use Bluetooth")
                case .restricted:
                    os_log("Bluetooth is restricted")
                default:
                    os_log("Unexpected authorization")
                }
            } else {
                // Fallback on earlier versions
            }
            return
        case .unknown:
            os_log("CBManager state is unknown")
            // In a real app, you'd deal with all the states accordingly
            return
        case .unsupported:
            os_log("Bluetooth is not supported on this device")
            // In a real app, you'd deal with all the states accordingly
            return
        @unknown default:
            os_log("A previously unknown peripheral manager state occurred")
            // In a real app, you'd deal with yet unknown cases that might occur in the future
            return
        }
    }
    
    /*
     *  Catch when someone subscribes to our characteristic, then start sending them data
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        os_log("Central subscribed to characteristic")
        
        // Get the data
        let name = UserDefaults.standard.string(forKey: "Key")
        // Get the data
        //        let randomString = NSUUID().uuidString
        let message = "[{'id':'bluetoothDetectDeom','message':'\(name ?? "")'}]"
        dataToSend =  message.data(using: String.Encoding.utf8)!//textView.text.data(using: .utf8)!
        
        // Reset the index
        sendDataIndex = 0
        
        // save central
        connectedCentral = central
        
        // Start sending
        sendData()
    }
    
    /*
     *  Recognize when the central unsubscribes
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        os_log("Central unsubscribed from characteristic")
        connectedCentral = nil
    }
    
    /*
     *  This callback comes in when the PeripheralManager is ready to send the next chunk of data.
     *  This is to ensure that packets will arrive in the order they are sent
     */
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        // Start sending again
        sendData()
    }
    
    /*
     * This callback comes in when the PeripheralManager received write to characteristics
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for aRequest in requests {
            guard let requestValue = aRequest.value,
                  let stringFromData = String(data: requestValue, encoding: .utf8) else {
                      continue
                  }
            
            os_log("Received write request of %d bytes: %s", requestValue.count, stringFromData)
            //            self.textView.text = stringFromData
        }
    }
}

//extension ViewController: UITextViewDelegate {
//    // implementations of the UITextViewDelegate methods
//
//    /*
//     *  This is called when a change happens, so we know to stop advertising
//     */
//    func textViewDidChange(_ textView: UITextView) {
//        // If we're already advertising, stop
//        if advertisingSwitch.isOn {
//            advertisingSwitch.isOn = false
//            peripheralManager.stopAdvertising()
//        }
//    }
//
//    /*
//     *  Adds the 'Done' button to the title bar
//     */
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        // We need to add this manually so we have a way to dismiss the keyboard
//        let rightButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
//        navigationItem.rightBarButtonItem = rightButton
//    }
//
//    /*
//     * Finishes the editing
//     */
//    @objc
//    func dismissKeyboard() {
//        textView.resignFirstResponder()
//        navigationItem.rightBarButtonItem = nil
//    }
//
//}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deviceNameListArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BluetoothTVCell = tableView.dequeueReusableCell(withIdentifier: "BluetoothTVCell", for: indexPath) as! BluetoothTVCell
        //        activityIndicator.isHidden = true
        cell.nameLbl.text = "\(deviceNameListArr[indexPath.row].devicName ?? "")"
        cell.currentSignalStrength.text = "\(deviceNameListArr[indexPath.row].signalStrength ?? 0) dBm"
        cell.averageSignalStrengthLbl.text = "\(deviceNameListArr[indexPath.row].averageSignalStrength ?? 0) dBm"
        cell.connectedOnLbl.text = "\(deviceNameListArr[indexPath.row].dateAndTime ?? "")"
        //        cell.durationLbl.text = "\(count) Sec"
        cell.locationLbl.text = "\(deviceNameListArr[indexPath.row].locationName ?? "")"
        
        cell.durationInRangeLbl?.text = "\(deviceNameListArr[indexPath.row].duration ?? "")"
        cell.durationAboveRangeLbl?.text = "\(deviceNameListArr[indexPath.row].durationAbove ?? "")"
        return cell
    }
}
extension Date {
    func today(format : String = "yyyy-MM-dd'T'HH:mm:ss.SSS") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ sublocality: String?,_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.subLocality,$0?.first?.locality, $0?.first?.country, $1) }
    }
}
