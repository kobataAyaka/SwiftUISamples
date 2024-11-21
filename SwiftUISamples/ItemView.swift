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
        VStack {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .gradientShadow(colors: [Color.yellow, Color.purple], offset: CGSize(width: 10, height: 10), cornerRadius: 50)
            Spacer()
            Text(item.name)
            Spacer()
        }
    }
}
