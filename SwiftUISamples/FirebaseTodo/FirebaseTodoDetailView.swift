import SwiftUI

struct FirebaseTodoDetailView: View {
    @ObservedObject var todoManager: FirebaseTodoManager
    let todo: FirebaseTodo
    @State private var isImageLoading = false
    
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
//                if let imageURL = todo.imageURL {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("添付画像")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                        
//                        AsyncImage(url: URL(string: imageURL)) { image in
//                            image
//                                .resizable()
//                                .scaledToFit()
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        } placeholder: {
//                            VStack {
//                                ProgressView()
//                                    .scaleEffect(1.2)
//                                Text("画像読み込み中...")
//                                    .font(.caption)
//                                    .foregroundColor(.secondary)
//                            }
//                            .frame(height: 200)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(10)
//                        }
//                        .onTapGesture {
//                            // 画像をフルスクリーンで表示（実装は後で）
//                        }
//                    }
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(10)
//                }
                
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
                            Text(todo.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("갱신일")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(todo.updatedAt.formatted(date: .abbreviated, time: .shortened))
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
//        imageURL: "https://via.placeholder.com/300x200",
        userID: "sample_user"
    )
    
    static let sampleCompletedTodo = FirebaseTodo(
        name: "完了したTodo",
        done: true,
//        imageURL: nil,
        userID: "sample_user"
    )
}

//#Preview {
//    NavigationStack {
//        FirebaseTodoDetailView(todo: .sampleTodo)
//    }
//}
