import SwiftUI
import PhotosUI

struct FirebaseTodoListView: View {
    @StateObject private var todoManager = FirebaseTodoManager()
    @State private var showingAddTodo = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                // エラーメッセージ表示
                if let errorMessage = todoManager.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                // ローディング表示
                if todoManager.isLoading {
                    ProgressView("読み込み中...")
                        .padding()
                }
                
                // Todo一覧
                List {
                    ForEach(todoManager.todos) { todo in
                        NavigationLink(destination: FirebaseTodoDetailView(todoManager: todoManager, todo: todo)) {
                            FirebaseTodoRowView(todo: todo, todoManager: todoManager)
                        }
                    }
                    .onDelete(perform: deleteTodos)
                }
                .refreshable {
                    await todoManager.fetchTodos()
                }
                
                // 追加ボタン
                HStack(spacing: 20) {
                    Button("テキストTodo追加") {
                        showingAddTodo = true
                    }
                    .buttonStyle(CapsuleButtonStyle())
                    
//                    Button("写真付きTodo追加") {
//                        showingAddTodoWithPhoto = true
//                    }
//                    .buttonStyle(CapsuleButtonStyle())
                }
                .padding()
                
                Button("戻る") {
                    dismiss()
                }
                .buttonStyle(CapsuleButtonStyle())
                .padding()
            }
            .navigationTitle("Firebase Todo")
            .onAppear {
                Task {
                    await todoManager.signInAnonymously()
                    await todoManager.fetchTodos()
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(todoManager: todoManager)
            }
//            .sheet(isPresented: $showingAddTodoWithPhoto) {
//                AddTodoWithPhotoView(todoManager: todoManager)
//            }
        }
    }
    
    private func deleteTodos(at offsets: IndexSet) {
        for index in offsets {
            let todo = todoManager.todos[index]
            Task {
                await todoManager.deleteTodo(todo)
            }
        }
    }
}

// MARK: - Todo行表示
struct FirebaseTodoRowView: View {
    let todo: FirebaseTodo
    let todoManager: FirebaseTodoManager
    
    var body: some View {
        HStack {
            Button(action: {
                Task {
                    await todoManager.toggleTodo(todo)
                }
            }) {
                Image(systemName: todo.done ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.done ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.name)
                    .strikethrough(todo.done)
                    .foregroundColor(todo.done ? .gray : .primary)
                
                Text(todo.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - テキストTodo追加画面
struct AddTodoView: View {
    @ObservedObject var todoManager: FirebaseTodoManager
    @State private var todoName = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Todo名を入力", text: $todoName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("追加") {
                    Task {
                        await todoManager.addTodo(name: todoName)
                        dismiss()
                    }
                }
                .buttonStyle(CapsuleButtonStyle())
                .disabled(todoName.isEmpty)
                
                Spacer()
            }
            .navigationTitle("Todo追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - 写真付きTodo追加画面
struct AddTodoWithPhotoView: View {
    @ObservedObject var todoManager: FirebaseTodoManager
    @State private var todoName = ""
    @State private var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Todo名を入力", text: $todoName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    Text("写真を選択")
                }
                .buttonStyle(CapsuleButtonStyle())
                
                Button("追加") {
                    Task {
                        if let image = selectedImage {
                            await todoManager.addTodoWithImage(name: todoName, image: image)
                        } else {
                            await todoManager.addTodo(name: todoName)
                        }
                        dismiss()
                    }
                }
                .buttonStyle(CapsuleButtonStyle())
                .disabled(todoName.isEmpty)
                
                Spacer()
            }
            .navigationTitle("写真付きTodo追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
            .onChange(of: photosPickerItem) { _, _ in
                Task {
                    if let photosPickerItem,
                       let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            selectedImage = image
                        }
                    }
                }
            }
        }
    }
}
