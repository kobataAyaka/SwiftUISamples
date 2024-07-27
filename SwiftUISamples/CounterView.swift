//
//  CounterView.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/28/24.
//

import Combine
import SwiftUI

class CounterViewModel: ObservableObject {
    @Published var count = 0
    
    func increment() {
        count += 1
    }
}

struct CounterView: View {
    @ObservedObject var viewModel = CounterViewModel()
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        VStack {
            Text("이부분은 CounterView입니다")
            Text("\(viewModel.count)")
            Button("커운트 하기") {
                viewModel.increment()
            }
            Button {
                navigationState.currentView = "content"
            } label: {
                Text("뒤로가기")
            }
            if navigationState.currentView == "Content" {
                ContentView()
            }
        }
        .background(Color(red: 0.7, green: 0.8, blue: 1.0).opacity(0.5))
    }
}
