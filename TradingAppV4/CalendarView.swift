import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("选择日期", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                TradesForDateView(date: selectedDate)
            }
            .navigationTitle("日历")
        }
    }
}

struct TradesForDateView: View {
    let date: Date
    
    @FetchRequest private var trades: FetchedResults<Trade>
    
    init(date: Date) {
        self.date = date
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        _trades = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Trade.entryDate, ascending: true)],
            predicate: NSPredicate(format: "entryDate >= %@ AND entryDate < %@", startOfDay as NSDate, endOfDay as NSDate)
        )
    }
    
    var body: some View {
        List {
            ForEach(trades) { trade in
                Text("交易: \(trade.product?.name ?? "") - \(trade.direction ?? "")")
            }
        }
    }
}
