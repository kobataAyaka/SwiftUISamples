//
//  TodoItemView.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 10/13/24.
//

import SwiftUI

struct TodoItemView: View {
    @State var item: Todo
    
    var body: some View {
        Text(item.name)
    }
}
