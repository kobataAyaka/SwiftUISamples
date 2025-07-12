import SwiftUI
import PhotosUI

struct FirebaseTodoListView: View {
    @StateObject private var todoManager = FirebaseTodoManager()
    @State private var showingAddTodo = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageState: LanguageState
    
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
                    ProgressView("로딩 중...")
                        .padding()
                }
                
                // Todo一覧
                List {
                    ForEach(todoManager.todos) { todo in
                        NavigationLink(destination: FirebaseTodoDetailView(todoManager: todoManager, todo: todo)) {
                            FirebaseTodoRowView(todo: todo, todoManager: todoManager, languageState: languageState)
                        }
                    }
                    .onDelete(perform: deleteTodos)
                }
                .refreshable {
                    await todoManager.fetchTodos()
                }
                
                // 追加ボタン
                HStack(spacing: 20) {
                    Button("Todo추가") {
                        showingAddTodo = true
                    }
                    .buttonStyle(CapsuleButtonStyle())
                    
//                    Button("写真付きTodo追加") {
//                        showingAddTodoWithPhoto = true
//                    }
//                    .buttonStyle(CapsuleButtonStyle())
                }
                .padding()
                
                Button("뒤로가기") {
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
    let languageState: LanguageState
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = languageState.type.locale
        return formatter
    }
    
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
                
                Text(dateFormatter.string(from: todo.createdAt))
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
                TextField("Todo제목을 입력", text: $todoName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("추가") {
                    Task {
                        await todoManager.addTodo(name: todoName)
                        dismiss()
                    }
                }
                .buttonStyle(CapsuleButtonStyle())
                .disabled(todoName.isEmpty)
                
                Spacer()
            }
            .navigationTitle("Todo추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("취소") {
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
                TextField("Todo제목을 입력", text: $todoName)
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
                    Text("사진 선택")
                }
                .buttonStyle(CapsuleButtonStyle())
                
                Button("추가") {
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
            .navigationTitle("사진첨부 Todo 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("취소") {
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
