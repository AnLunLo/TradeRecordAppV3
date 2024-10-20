import SwiftUI

struct TradeRowView: View {
    let trade: Trade
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("ID: \(trade.id?.uuidString.prefix(8) ?? "")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(trade.direction ?? "")
                    .font(.caption)
                    .padding(4)
                    .background(trade.direction == "多" ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Text("\(trade.product?.name ?? "") - \(trade.strategy?.name ?? "")")
                .font(.headline)
            
            HStack {
                Text("进场时间: \(formattedDate(trade.entryDate))")
                Spacer()
                Text("进场点: \(String(format: "%.2f", trade.entryPrice))")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}
