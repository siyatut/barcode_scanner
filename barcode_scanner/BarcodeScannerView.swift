//
//  ContentView.swift
//  barcode_scanner
//
//  Created by Anastasia Tyutinova on 21/8/2568 BE.
//

import SwiftUI
import CoreData

struct BarcodeScannerView: View {
    var body: some View {
        NavigationView {
            VStack {
               ScannerView()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer().frame(height: 60)
                
                Label("Scanned Barcode:", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                Text("Not yet scanned")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
        }
    }
}

#Preview {
    BarcodeScannerView()
}
