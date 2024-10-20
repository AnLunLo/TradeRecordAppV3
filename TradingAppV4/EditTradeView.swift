import SwiftUI

struct EditTradeView: View {
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
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    Picker("商品", selection: $selectedProduct) {
                        ForEach(products, id: \.self) { product in
                            Text(product.name ?? "").tag(product as Product?)
                        }
                    }
                    
                    Picker("策略", selection: $selectedStrategy) {
                        ForEach(strategies, id: \.self) { strategy in
                            Text(strategy.name ?? "").tag(strategy as Strategy?)
                        }
                    }
                    
                    Picker("方向", selection: $direction) {
                        Text("多").tag("多")
                        Text("空").tag("空")
                    }
                }
                
                Section(header: Text("价格信息")) {
                    TextField("进场点", text: $entryPrice)
                        .keyboardType(.decimalPad)
                    TextField("预计停损点", text: $stopLoss)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("时间信息")) {
                    DatePicker("进场日期", selection: $entryDate, displayedComponents: .date)
                    DatePicker("进场时间", selection: $entryTime, displayedComponents: .hourAndMinute)
                    
                    Toggle("设置出场时间", isOn: Binding<Bool>(
                        get: { self.exitDate != nil },
                        set: { if $0 { self.exitDate = Date(); self.exitTime = Date() } else { self.exitDate = nil; self.exitTime = nil } }
                    ))
                    
                    if exitDate != nil {
                        DatePicker("出场日期", selection: Binding($exitDate)!, displayedComponents: .date)
                        DatePicker("出场时间", selection: Binding($exitTime)!, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle("编辑交易")
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    saveChanges()
                }
            )
        }
    }
    
    private func saveChanges() {
        trade.product = selectedProduct
        trade.strategy = selectedStrategy
        trade.direction = direction
        trade.entryPrice = Double(entryPrice) ?? trade.entryPrice
        trade.stopLoss = Double(stopLoss) ?? trade.stopLoss
        
        let calendar = Calendar.current
        trade.entryDate = calendar.date(bySettingHour: calendar.component(.hour, from: entryTime),
                                        minute: calendar.component(.minute, from: entryTime),
                                        second: 0,
                                        of: entryDate)
        
        if let exitDate = exitDate, let exitTime = exitTime {
            trade.exitDate = calendar.date(bySettingHour: calendar.component(.hour, from: exitTime),
                                           minute: calendar.component(.minute, from: exitTime),
                                           second: 0,
                                           of: exitDate)
        } else {
            trade.exitDate = nil
        }
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("保存更改失败: \(error)")
        }
    }
}
