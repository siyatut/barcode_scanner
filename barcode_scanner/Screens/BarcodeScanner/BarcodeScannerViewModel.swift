//
//  BarcodeScannerViewModel.swift
//  barcode_scanner
//
//  Created by Anastasia Tyutinova on 22/8/2568 BE.
//

import SwiftUI

@MainActor
final class BarcodeScannerViewModel: ObservableObject {
    
    @Published var scannedCode = ""
    @Published var error: CameraError?
    
    var statusText: String {
        scannedCode.isEmpty ? "Not yet scanned" : scannedCode
    }
    
    var statusTextColor: Color {
        scannedCode.isEmpty ? .red : .green
    }
}
