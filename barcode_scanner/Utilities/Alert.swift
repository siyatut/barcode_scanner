//
//  Alert.swift
//  barcode_scanner
//
//  Created by Anastasia Tyutinova on 22/8/2568 BE.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput = AlertItem(title: "Invalid device input",
                                              message: "Something went wrong while creating the video input. We are unable to scan barcodes.",
                                              dismissButton: .default(Text("Ok")))
    static let invalidScannedType = AlertItem(title: "Invalid Scan Type",
                                              message: "The value scanned is not valid. This app scans EAN-8 and EAN-13.",
                                              dismissButton: .default(Text("Ok")))
}
