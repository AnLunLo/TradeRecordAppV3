import SwiftUI
import CoreData

struct OpenTradesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trade.entryDate, ascending: false)],
        predicate: NSPredicate(format: "exitDate == nil")
    ) private var openTrades: FetchedResults<Trade>
    
    @State private var showingEditView = false
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
                                Label("删除", systemImage: "trash")
                            }
                            
                            Button {
                                selectedTrade = trade
                                showingEditView = true
                            } label: {
                                Label("编辑", systemImage: "pencil")
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
            print("删除交易失败: \(error)")
        }
    }
}
