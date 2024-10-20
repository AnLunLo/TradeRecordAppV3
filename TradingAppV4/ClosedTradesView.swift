import SwiftUI
import CoreData

struct ClosedTradesView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trade.exitDate, ascending: false)],
        predicate: NSPredicate(format: "exitDate != nil")
    ) private var closedTrades: FetchedResults<Trade>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(closedTrades) { trade in
                    Text("已完成交易: \(trade.product?.name ?? "") - \(trade.direction ?? "")")
                }
            }
            .navigationTitle("已完成交易")
        }
    }
}
