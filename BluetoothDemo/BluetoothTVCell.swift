//
//  BluetoothTVCell.swift
//  BluetoothDemo
//
//  Created by Akshay on 12/10/22.
//

import UIKit

class BluetoothTVCell: UITableViewCell {

    @IBOutlet weak var currentSignalStrength: UILabel!
    @IBOutlet weak var averageSignalStrengthLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var connectedOnLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var durationInRangeLbl: UILabel!
    @IBOutlet weak var durationAboveRangeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

