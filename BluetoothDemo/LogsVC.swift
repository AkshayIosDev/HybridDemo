//
//  LogsVC.swift
//  BluetoothDemo
//
//  Created by Akshay on 29/12/22.
//

import UIKit

class LogsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: "DeviceLogsTVCell", bundle: nil), forCellReuseIdentifier: "DeviceLogsTVCell")
        }
    }
    var isClear = false
    var callBack:(() -> ())?
    var deviceLogsListArr:[DeviceLogData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        deviceLogsListArr = Defaults.userLogs
        // Do any additional setup after loading the view.
    }
  
    @IBAction func handleBackBtn(_ sender: Any) {
        if isClear{
            callBack?()
        }
        popVC()
    }
    
    @IBAction func handleClearBtn(_ sender: Any) {
        isClear = true
        Defaults.removeUserLogsData()
        deviceLogsListArr.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
extension LogsVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deviceLogsListArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DeviceLogsTVCell = tableView.dequeueReusableCell(withIdentifier: "DeviceLogsTVCell", for: indexPath) as! DeviceLogsTVCell
        cell.logLbl.text = deviceLogsListArr[indexPath.row].log
       
        return cell
    }
}
