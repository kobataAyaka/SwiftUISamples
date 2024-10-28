//
//  NotionListView.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 10/13/24.
//

import SwiftUI

struct Todo: Hashable, Codable {
    let id: UUID
    var name: String
    var done: Bool
    
    init(id: UUID = UUID(), name: String, done: Bool) {
        self.id = id
        self.name = name
        self.done = done
    }
}

class TodoModel: ObservableObject {
    @Published var items: [Todo] = []
    
    func loadTodos() {
        APIClient.shared.fetchTodos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todos):
                    self?.items = todos
                case .failure(let error):
                    print("Failed to load todos: \(error)")
                }
            }
        }
    }
}

struct NotionListView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var model = TodoModel()
    
    var body: some View {
        NavigationStack {
            List(model.items, id: \.self) { item in
                NavigationLink(value: item) {
                    Text(item.name)
                }
            }
            .navigationTitle(Text("Notion Database"))
            .navigationDestination(for: Todo.self) { value in
                TodoItemView(item: value)
            }
            .onAppear {
                model.loadTodos()
            }
            
            Button {
                dismiss()
            } label: {
                Text("클릭하면 화면을 닫습니다.")
            }
        }
    }
}
