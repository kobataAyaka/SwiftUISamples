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
                .font(.largeTitle) // 숫자를 보기 쉽게 폰트 크기를 키웁니다
                // 숫자가 바뀔 때 애니메이션(확대/축소 및 페이드)을 추가합니다
                .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .scale.combined(with: .opacity)))
                .id(viewModel.count) // 애니메이션이 올바르게 작동하도록 뷰에 고유 ID를 부여합니다
            Button("카운트 하기") {
                // withAnimation으로 처리를 감싸서 상태 변경 시 애니메이션이 적용되도록 합니다
                withAnimation {
                    viewModel.increment()
                }
            }
            Button {
                withAnimation {
                    navigationState.currentView = "content"
                }
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
