//
//  Persistence.swift
//  TradingAppV4
//
//  Created by Aaron Lo on 2024/10/20.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // 创建一些示例产品
        let products = ["BTCUSDT", "ETHUSDT", "BNBUSDT"]
        var createdProducts: [Product] = []
        for productName in products {
            let newProduct = Product(context: viewContext)
            newProduct.name = productName
            newProduct.id = UUID()
            createdProducts.append(newProduct)
        }
        
        // 创建一些示例策略
        let strategies = ["趋势跟随", "反转交易", "突破交易"]
        var createdStrategies: [Strategy] = []
        for strategyName in strategies {
            let newStrategy = Strategy(context: viewContext)
            newStrategy.name = strategyName
            newStrategy.id = UUID()
            newStrategy.content = "这是\(strategyName)策略的描述"
            createdStrategies.append(newStrategy)
        }
        
        // 创建示例交易
        for i in 0..<10 {
            let newTrade = Trade(context: viewContext)
            newTrade.id = UUID()
            newTrade.entryDate = Date().addingTimeInterval(Double(-i * 86400)) // 每个交易间隔一天
            newTrade.entryPrice = Double.random(in: 10000...50000)
            newTrade.stopLoss = newTrade.entryPrice * 0.95 // 假设止损点为入场价格的95%
            newTrade.direction = i % 2 == 0 ? "多" : "空"
            newTrade.product = createdProducts[i % createdProducts.count]
            newTrade.strategy = createdStrategies[i % createdStrategies.count]
            
            // 随机设置一些交易为已完成状态
            if i % 3 == 0 {
                newTrade.exitDate = Date()
                newTrade.exitPrice = newTrade.direction == "多" ? newTrade.entryPrice * 1.1 : newTrade.entryPrice * 0.9
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TradingAppV4")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
