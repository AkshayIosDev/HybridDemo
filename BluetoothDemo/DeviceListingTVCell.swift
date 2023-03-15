//
//  DeviceListingTVCell.swift
//  BluetoothDemo
//
//  Created by Akshay on 29/12/22.
//

import UIKit

class DeviceListingTVCell: UITableViewCell {
    @IBOutlet weak var deviceNameLbl: UILabel!
    @IBOutlet weak var macAddressLbl: UILabel!
    @IBOutlet weak var signalStrLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var durationAboveLbl: UILabel!
    @IBOutlet weak var dateAndTimeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
