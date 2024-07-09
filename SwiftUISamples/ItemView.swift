//
//  ItemView.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/9/24.
//

import SwiftUI

struct ItemView: View {
    @State var itemName: String
    
    var body: some View {
        Text(itemName)
    }
}
