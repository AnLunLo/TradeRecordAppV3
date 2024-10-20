import SwiftUI

struct TradeDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var trade: Trade
    
    @State private var selectedProduct: Product?
    @State private var selectedStrategy: Strategy?
    @State private var direction: String
    @State private var entryPrice: String
    @State private var stopLoss: String
    @State private var entryDate: Date
    @State private var entryTime: Date
    @State private var exitDate: Date?
    @State private var exitTime: Date?
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Strategy.name, ascending: true)],
        animation: .default)
    private var strategies: FetchedResults<Strategy>
    //// 初始化方法，设置状态变量的初始值
    init(trade: Trade) {
        self.trade = trade
        _selectedProduct = State(initialValue: trade.product)
        _selectedStrategy = State(initialValue: trade.strategy)
        _direction = State(initialValue: trade.direction ?? "多")
        _entryPrice = State(initialValue: String(trade.entryPrice))
        _stopLoss = State(initialValue: String(trade.stopLoss))
        _entryDate = State(initialValue: trade.entryDate ?? Date())
        _entryTime = State(initialValue: trade.entryDate ?? Date())
        _exitDate = State(initialValue: trade.exitDate)
        _exitTime = State(initialValue: trade.exitDate)
    }

    var body: some View {
        List {
            // 交易信息
            Section(header: Text("交易信息")) {
                Text("商品: \(selectedProduct?.name ?? "未知")")
                Text("策略: \(selectedStrategy?.name ?? "未知")")
                Text("方向: \(direction)")
                Text("进场价格: \(entryPrice)")
                Text("预计停损点: \(stopLoss)")
                Text("进场日期: \(entryDate, formatter: itemFormatter)")
                Text("进场时间: \(entryTime, formatter: itemFormatter)")
                if let exitDate = exitDate {
                    Text("出场日期: \(exitDate, formatter: itemFormatter)")
                    if let exitTime = exitTime {
                        Text("出场时间: \(exitTime, formatter: itemFormatter)")
                    }
                }
            }
        }
        .navigationTitle("交易詳情")
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
