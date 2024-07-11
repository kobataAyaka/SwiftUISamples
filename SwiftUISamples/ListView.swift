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
    var image: String
}

@Observable class ItemModel: ObservableObject {
    var items: [Item] = [
        Item(name: "사과", net: 200.0, image: "apple"),
            Item(name: "우유", net: 1000.0, image: "milk"),
            Item(name: "계란", net: 60.0, image: "egg"),
            Item(name: "김치", net: 500.0, image: "kimchi")
        ]
}

struct ListView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var model = ItemModel()
    
    var body: some View {
        NavigationStack {
            List(model.items, id: \.self) { item in
                NavigationLink(value: item) {
                    Text(item.name)
                    Text("\(item.net, specifier: "%.2f") g")
                }
            }
            .navigationTitle(Text("ListView"))
            .navigationDestination(for: Item.self) { value in
                ItemView(item: value)
            }
            
            Button {
                dismiss()
            } label: {
                Text("클릭하면 화면을 닫습니다.")
            }
        }
    }
}
