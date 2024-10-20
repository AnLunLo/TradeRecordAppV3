import SwiftUI

struct AddTradeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Strategy.name, ascending: true)],
        animation: .default)
    private var strategies: FetchedResults<Strategy>
    
    @State private var selectedProduct: Product?
    @State private var selectedStrategy: Strategy?
    @State private var direction: String = "多"
    @State private var entryPrice: String = ""
    @State private var stopLoss: String = ""
    @State private var entryDate = Date()
    @State private var entryTime = Date()
    @State private var exitDate: Date?
    @State private var exitTime: Date?
    
    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                Picker("商品", selection: $selectedProduct) {
                    Text("请选择").tag(nil as Product?)
                    ForEach(products, id: \.self) { product in
                        Text(product.name ?? "").tag(product as Product?)
                    }
                }
                
                Picker("策略", selection: $selectedStrategy) {
                    Text("请选择").tag(nil as Strategy?)
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
                DatePicker("出场日期", selection: Binding<Date>(
                    get: { self.exitDate ?? Date() },
                    set: { self.exitDate = $0 }
                ), displayedComponents: .date)
                .disabled(exitDate == nil)
                DatePicker("出场时间", selection: Binding<Date>(
                    get: { self.exitTime ?? Date() },
                    set: { self.exitTime = $0 }
                ), displayedComponents: .hourAndMinute)
                .disabled(exitTime == nil)
                
                Toggle("设置出场时间", isOn: Binding<Bool>(
                    get: { self.exitDate != nil },
                    set: { if $0 { self.exitDate = Date(); self.exitTime = Date() } else { self.exitDate = nil; self.exitTime = nil } }
                ))
            }
        }
        .navigationTitle("新增交易")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    saveTrade()
                }
                .disabled(!isFormValid)
            }
        }
    }
    
    private var isFormValid: Bool {
        guard let product = selectedProduct,
              let strategy = selectedStrategy,
              !entryPrice.isEmpty,
              !stopLoss.isEmpty,
              let entryPriceValue = Double(entryPrice),
              let stopLossValue = Double(stopLoss),
              entryPriceValue > 0,
              stopLossValue > 0 else {
            return false
        }
        return true
    }
    
    private func saveTrade() {
        guard isFormValid else { return }
        
        let newTrade = Trade(context: viewContext)
        newTrade.id = UUID()
        newTrade.product = selectedProduct
        newTrade.strategy = selectedStrategy
        newTrade.direction = direction
        newTrade.entryPrice = Double(entryPrice) ?? 0
        newTrade.stopLoss = Double(stopLoss) ?? 0
        
        let calendar = Calendar.current
        newTrade.entryDate = calendar.date(bySettingHour: calendar.component(.hour, from: entryTime),
                                           minute: calendar.component(.minute, from: entryTime),
                                           second: 0,
                                           of: entryDate)
        
        if let exitDate = exitDate, let exitTime = exitTime {
            newTrade.exitDate = calendar.date(bySettingHour: calendar.component(.hour, from: exitTime),
                                              minute: calendar.component(.minute, from: exitTime),
                                              second: 0,
                                              of: exitDate)
        }
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

