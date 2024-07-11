//
//  ItemView.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/9/24.
//

import SwiftUI

struct ItemView: View {
    @State var item: Item
    
    var body: some View {
        Image(item.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
        Text(item.name)
    }
}
