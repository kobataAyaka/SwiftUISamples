//
//  SecondView.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/5/24.
//

import SwiftUI

struct SecondView: View {
    @Binding var presentingModal: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("second view!")
            Button {
                self.presentingModal = false
            } label: {
                Text("@Binding을 이용한 닫기 버튼")
            }
            Button {
                dismiss()
            } label: {
                Text("@Environment를 이용한 닫기 버튼")
            }

        }
    }
}
