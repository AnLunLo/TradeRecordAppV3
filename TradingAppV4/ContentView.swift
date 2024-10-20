//
//  ContentView.swift
//  TradingAppV4
//
//  Created by Aaron Lo on 2024/10/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            OpenTradesView()
                .tabItem {
                    Label("未完成", systemImage: "clock")
                }
                .tag(0)
            
            ClosedTradesView()
                .tabItem {
                    Label("已完成", systemImage: "checkmark.circle")
                }
                .tag(1)
            
            CalendarView()
                .tabItem {
                    Label("日历", systemImage: "calendar")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
