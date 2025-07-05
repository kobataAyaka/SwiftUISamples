//
//  CounterViewModelTests.swift
//  SwiftUISamplesTest
//
//  Created by 小幡綾加 on 7/5/25.
//

import Testing
@testable import SwiftUISamples

struct CounterViewModelTests {
    
    @Test func increment() {
        let viewModel = CounterViewModel()
        let initialCount = viewModel.count
        
        viewModel.increment()
        #expect(viewModel.count == initialCount + 1)
    }
    
    @Test func counterStartsAtZero() {
        let viewModel = CounterViewModel()
        #expect(viewModel.count == 0)
    }
}

struct TodoModelTests {
    @Test func todoCreation() {
        let todo = Todo(name: "테스트 타스크", done: false)
        #expect(todo.name == "테스트 타스크")
        #expect(!todo.done)
    }
}
