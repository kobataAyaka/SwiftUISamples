//
//  ContentView.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/5/24.
//

import SwiftUI

struct ContentView: View {
    @State var presentingModal = false
    @State var fullscreenList = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, git-flow world!")
            Button {
                self.presentingModal = true
            } label: {
                Text("Sheet 표시 버튼")
            }
            .sheet(isPresented: $presentingModal) {
                SecondView(presentingModal: $presentingModal)
            }
            
            Button {
                self.fullscreenList = true
            } label: {
                Text("fullscreen ListView 표시 버튼")
            }
            .fullScreenCover(isPresented: $fullscreenList) {
                ListView()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
