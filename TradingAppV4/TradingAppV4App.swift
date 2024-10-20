//
//  TradingAppV4App.swift
//  TradingAppV4
//
//  Created by Aaron Lo on 2024/10/20.
//

import SwiftUI

@main
struct TradingAppV4App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
