import SwiftUI
import CoreData

struct OpenTradesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    // 使用 FetchRequest 從 Core Data 獲取未完成的交易
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trade.entryDate, ascending: false)],
        predicate: NSPredicate(format: "exitDate == nil")
    ) private var openTrades: FetchedResults<Trade>
    
    // 控制編輯視圖的顯示
    @State private var showingEditView = false
    // 存儲當前選中的交易
    @State private var selectedTrade: Trade?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(openTrades) { trade in
                    TradeRowView(trade: trade)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteTrade(trade)
                            } label: {
                                Label("刪除", systemImage: "trash")
                            }
                            
                            Button {
                                selectedTrade = trade
                                showingEditView = true
                            } label: {
                                Label("編輯", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("未完成交易")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTradeView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingEditView) {
                if let trade = selectedTrade {
                    EditTradeView(trade: trade)
                }
            }
        }
    }
    
    private func deleteTrade(_ trade: Trade) {
        viewContext.delete(trade)
        do {
            try viewContext.save()
        } catch {
            print("刪除失败: \(error)")
        }
    }
}
