import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ProductListView()) {
                    Text("商品设置")
                }
                NavigationLink(destination: StrategyListView()) {
                    Text("策略设置")
                }
            }
            .navigationTitle("设置")
        }
    }
}

struct ProductListView: View {
    var body: some View {
        Text("商品列表")
    }
}

struct StrategyListView: View {
    var body: some View {
        Text("策略列表")
    }
}
