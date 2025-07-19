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
    @State var firebaseList = false
    @State var isShowLanguagePicker: Bool = false
    @EnvironmentObject var languageState: LanguageState
    @State var testTodoText: String = ""
    @State var testTodoMessage: String = ""
    
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
            Button {
                self.firebaseList = true
            } label: {
                Text("Firebase Database 표시 버튼")
            }
            .fullScreenCover(isPresented: $firebaseList) {
                FirebaseTodoListView()
            }
            
            TextField("Supabase 테스트 Todo 입력", text: $testTodoText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button {
                Task {
                    do {
                        try await addTestTodo(text: testTodoText)
                        testTodoText = "" // 入力フィールドをクリア
                        testTodoMessage = "Supabase 테스트 Todo 추가 성공!"
                    } catch {
                        testTodoMessage = "Supabase 테스트 Todo 추가 실패: \(error.localizedDescription)"
                    }
                }
            } label: {
                Text("Supabase 테스트 Todo 추가")
            }
            
            Text(testTodoMessage)
                .foregroundColor(.blue)
                .padding(.bottom)
            
            Button {
                self.isShowLanguagePicker.toggle()
            } label: {
                Label("언어설정", systemImage: "globe")
            }
            .sheet(isPresented: $isShowLanguagePicker) {
                NavigationStack {
                    Picker("언어 선택", selection: $languageState.type) {
                        Text("한국어").tag(LanguageType.Korean)
                        Text("일본어").tag(LanguageType.Japanese)
                        Text("영어").tag(LanguageType.English)
                        Text("기본설정").tag(LanguageType.Default)
                    }
                    .pickerStyle(.wheel)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("닫기") {
                                isShowLanguagePicker = false
                            }
                        }
                    }
                }
            }
        }
        .environment(\.locale, languageState.type.locale)
        .buttonStyle(CapsuleButtonStyle())
        .padding()
    }
}

//#Preview {
//    ContentView()
//}
