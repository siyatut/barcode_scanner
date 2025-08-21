//
//  barcode_scannerApp.swift
//  barcode_scanner
//
//  Created by Anastasia Tyutinova on 21/8/2568 BE.
//

import SwiftUI

@main
struct barcode_scannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
