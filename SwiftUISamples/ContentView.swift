//
//  ContentView.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/5/24.
//

import SwiftUI

class NavigationState: ObservableObject {
    @Published var currentView: String = "content"
}

struct ContentView: View {
    @State var presentingModal = false
    @State var fullscreenList = false
    @EnvironmentObject var navigationState: NavigationState
    @State var notionList = false
    
    var body: some View {
        VStack {
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
            
            Button {
                navigationState.currentView = "countUp"
            } label: {
                Text("@EnvironmentObject를 이용한 CountView 표시 버튼")
            }
            if navigationState.currentView == "countUp" {
                CounterView()
            }
            
            Button {
                self.notionList = true
            } label: {
                Text("Notion Database 표시 버튼")
            }
            .fullScreenCover(isPresented: $notionList) {
                NotionListView()
            }
        }
        .buttonStyle(CapsuleButtonStyle())
        .padding()
    }
}

#Preview {
    ContentView()
}
