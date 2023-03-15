//
//  Definitions.swift
//  BluetoothDemo
//
//  Created by Akshay on 15/10/22.
//

import CoreBluetooth
var isInBackground = false
var isInForground = false
let TRANSFER_SERVICE_UUID = "E20A39F4-73F5-4BC4-A12F-17D1AD666661"
let TRANSFER_SERVICE_UUIDSCND = "E20A39F4-73F5-4BC4-A12F-17D1AD666662"
let TRANSFER_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-8757-72F6F66666D4"
let NOTIFY_MTU = 20

let transferServiceUUID = CBUUID(string: TRANSFER_SERVICE_UUID)
let transferServiceUUIDScnd = CBUUID(string: TRANSFER_SERVICE_UUIDSCND)
let transferCharacteristicUUID = CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)

