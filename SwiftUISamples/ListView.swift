//
//  ListView.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/8/24.
//

import SwiftUI

struct ListView: View {
    @Environment(\.dismiss) var dismiss
    let items = ["사과", "우유", "계란", "김치"]
    
    var body: some View {
        NavigationStack {
            List(items, id: \.self) { item in
                NavigationLink(value: item) {
                    Text(item)
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
