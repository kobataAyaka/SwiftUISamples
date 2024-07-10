//
//  ListView.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/8/24.
//

import SwiftUI

struct Item: Hashable {
    let id = UUID()
    var name: String
    var net: Float
}

@Observable class ItemModel: ObservableObject {
    var items: [Item] = [
            Item(name: "사과", net: 200.0),
            Item(name: "우유", net: 1000.0),
            Item(name: "계란", net: 60.0),
            Item(name: "김치", net: 500.0)
        ]
}

struct ListView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var model = ItemModel()
    
    var body: some View {
        NavigationStack {
            List(model.items, id: \.self) { item in
                NavigationLink(value: item.name) {
                    Text(item.name)
                    Text("\(item.net, specifier: "%.2f") g")
                }
            }
            .navigationTitle(Text("ListView"))
            .navigationDestination(for: String.self) { value in
                ItemView(itemName: value)
            }
            
            Button {
                dismiss()
            } label: {
                Text("클릭하면 화면을 닫습니다.")
            }
        }
    }
}
