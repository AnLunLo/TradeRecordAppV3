//
//  ContentView.swift
//  TradingAppV4
//
//  Created by Aaron Lo on 2024/10/20.
//

// 導入必要的框架
import SwiftUI
import CoreData

// 定義主要的內容視圖結構
struct ContentView: View {
    // 使用 @State 來管理選中的標籤頁
    @State private var selectedTab = 0
    
    // 定義視圖的主體
    var body: some View {
        // 使用 TabView 來創建底部標籤欄
        TabView(selection: $selectedTab) {
            // 未完成交易視圖
            OpenTradesView()
                .tabItem {
                    // 設置標籤項的圖標和文字
                    Label("未平倉", systemImage: "clock")
                }
                .tag(0) // 設置標籤的標識符
            
            // 已完成交易視圖
            ClosedTradesView()
                .tabItem {
                    Label("已結束", systemImage: "checkmark.circle")
                }
                .tag(1)
            
            // 日曆視圖
            CalendarView()
                .tabItem {
                    Label("日曆", systemImage: "calendar")
                }
                .tag(2)
            
            // 設置視圖
            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
                .tag(3)
        }
    }
}

// 為 Xcode 預覽功能提供一個預覽
#Preview {
    // 創建 ContentView 的預覽，並注入預覽用的 Core Data 管理對象上下文
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
