import SwiftUI

struct FirebaseTodoDetailView: View {
    @EnvironmentObject var languageState: LanguageState
    @ObservedObject var todoManager: FirebaseTodoManager
    let todo: FirebaseTodo
    @State private var isImageLoading = false

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = languageState.type.locale
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Todo情報
                VStack(alignment: .leading, spacing: 10) {
                    Text("Todo제목")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(todo.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .strikethrough(todo.done)
                        .foregroundColor(todo.done ? .gray : .primary)
                    
                    HStack {
                        Image(systemName: todo.done ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(todo.done ? .green : .gray)
                        Text(todo.done ? "완료" : "미완료")
                            .fontWeight(.medium)
                            .foregroundColor(todo.done ? .green : .orange)
                    }
                    .font(.subheadline)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // MARK: - 完了・未完了切り替えボタン
                Button(action: {
                    Task {
                        await todoManager.toggleTodo(todo)
                    }
                }) {
                    HStack {
                        Image(systemName: todo.done ? "arrow.uturn.backward.circle" : "checkmark.circle.fill")
                        Text(todo.done ? "미완료로 되돌리기" : "완료로 하기")
                    }
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(todo.done ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                // 画像表示
                if let imageURL = todo.imageURL {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("添付画像")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        AsyncImage(url: URL(string: imageURL)) { phase in
                            switch phase {
                            case .empty:
                                // 画像読み込み中のプレースホルダー
                                VStack {
                                    ProgressView()
                                        .scaleEffect(1.2)
                                    Text("画像読み込み中...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            case .success(let image):
                                // 読み込み成功
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            case .failure(let error):
                                // 読み込み失敗
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.secondary)
                                    Text("画像の読み込みに失敗しました")
                                        .font(.caption)
                                    // エラーの詳細を表示（デバッグ用）
                                    Text(error.localizedDescription)
                                        .font(.caption2)
                                        .foregroundColor(.red)
                                        .padding()
                                }
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .onTapGesture {
                            // 画像をフルスクリーンで表示（実装は後で）
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // 作成・更新日時
                VStack(alignment: .leading, spacing: 10) {
                    Text("상세정보")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("작성일")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(dateFormatter.string(from: todo.createdAt))
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("갱신일")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(dateFormatter.string(from: todo.updatedAt))
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .onAppear {
                Task {
                    do {
                        let (data, response) = try await URLSession.shared.data(from: URL(string: todo.imageURL!)!)
                        print("✅ HTTP Response: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                        print("✅ Content Type: \((response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Content-Type") ?? "unknown")")
                        print("✅ Image size: \(data.count) bytes")
                        let uiImage = UIImage(data: data)
                        print("✅ UIImage: \(uiImage != nil ? "OK" : "NG")")
                    } catch {
                        print("❌ Error: \(error)")
                    }
                }
            }
        }
        .navigationTitle("Todo 상세")
        .navigationBarTitleDisplayMode(.inline)
    }
}



// MARK: - プレビュー用サンプルデータ
extension FirebaseTodo {
    static let sampleTodo = FirebaseTodo(
        name: "Firebase連携のテスト",
        done: false,
        userID: "sample_user",
        imageURL: "https://via.placeholder.com/300x200"
    )
    
    static let sampleCompletedTodo = FirebaseTodo(
        name: "完了したTodo",
        done: true,
        userID: "sample_user",
        imageURL: nil
    )
}

//#Preview {
//    NavigationStack {
//        FirebaseTodoDetailView(todo: .sampleTodo)
//    }
//}
