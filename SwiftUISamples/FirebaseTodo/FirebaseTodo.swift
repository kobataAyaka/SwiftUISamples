import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

extension DocumentID: @unchecked @retroactive Sendable {}
extension StorageMetadata: @unchecked @retroactive Sendable {}
extension StorageReference: @unchecked Sendable {}
extension AuthDataResult: @unchecked Sendable {}

// Firebase用のTodoモデル
struct FirebaseTodo: Codable, Identifiable, Hashable, Sendable {
    @DocumentID var id: String?
    var name: String
    var done: Bool
    var createdAt: Date
    var updatedAt: Date
    var userID: String
    var imageURL: String?
    
    init(name: String, done: Bool = false, userID: String, imageURL: String? = nil) {
        self.name = name
        self.done = done
        self.createdAt = Date()
        self.updatedAt = Date()
        self.userID = userID
        self.imageURL = imageURL
    }
    
    // Firestoreのタイムスタンプ対応
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case done
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userID = "user_id"
        case imageURL = "image_url"
    }
}

// Firebase操作用のマネージャークラス
@MainActor
class FirebaseTodoManager: ObservableObject {
    @Published var todos: [FirebaseTodo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    // 現在のユーザーID
    private var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
    
    // 匿名認証でサインインする関数
    func signInAnonymously() async {
        // 既にサインインしている場合は何もしない
        if Auth.auth().currentUser != nil {
            return
        }
        
        do {
            try await Auth.auth().signInAnonymously()
        } catch {
            self.errorMessage = "サインインに失敗しました: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Todo一覧取得
    func fetchTodos() async {
        isLoading = true
        errorMessage = nil
        
        guard let userID = currentUserID else {
            self.errorMessage = "ユーザーがサインインしていません。"
            isLoading = false
            return
        }
        
        do {
            let snapshot = try await db.collection("todos")
                .whereField("user_id", isEqualTo: userID)
                .order(by: "created_at", descending: true)
                .getDocuments()
            
            self.todos = snapshot.documents.compactMap { document in
                try? document.data(as: FirebaseTodo.self)
            }
        } catch {
            self.errorMessage = "データの取得に失敗しました: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Todo追加（テキストのみ）
    func addTodo(name: String) async {
        guard let userID = currentUserID else {
            self.errorMessage = "사용자가 사인인되어있지 않습니다."
            return
        }
        let todo = FirebaseTodo(name: name, userID: userID)
        
        do {
            try db.collection("todos").addDocument(from: todo)
            await fetchTodos() // 再取得
        } catch {
            self.errorMessage = "Todo의 추가에 실패했습니다: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Todo追加（画像付き）
    func addTodoWithImage(name: String, image: UIImage) async {
        guard let userID = currentUserID else {
            self.errorMessage = "사용자가 사인인되어있지 않습니다."
            return
        }
        isLoading = true
        var finalImageURL: String? = nil

        do {
            // Firebaseへのアップロードを試みる
            finalImageURL = try await uploadImage(image, userID: userID)
            
        } catch let error where (error as NSError).domain == StorageErrorDomain {
            // Firebase Storageのエラーの場合、Supabaseにフォールバック
            print("Firebase upload failed, trying Supabase. Error: \(error.localizedDescription)")

            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                self.errorMessage = "Image conversion failed."
                self.isLoading = false
                return
            }
            let fileName = "\(UUID().uuidString).jpg"

            do {
                // SupabaseにアップロードしてURLを取得
                finalImageURL = try await SupabaseService.uploadImage(imageData: imageData, fileName: fileName)
                print("Supabase upload successful.")

            } catch {
                // Supabaseも失敗
                self.errorMessage = "Image upload failed for both Firebase and Supabase: \(error.localizedDescription)"
                isLoading = false
                return
            }

        } catch {
            // その他の予期せぬエラー
            self.errorMessage = "Failed to add todo with image: \(error.localizedDescription)"
            isLoading = false
            return
        }
        
        // Todoを作成してFirestoreに保存
        do {
            let todo = FirebaseTodo(name: name, userID: userID, imageURL: finalImageURL)
            try db.collection("todos").addDocument(from: todo)
            await fetchTodos() // 一覧を再取得
        } catch {
            self.errorMessage = "Todoの追加に失敗しました: \(error.localizedDescription)"
        }

        isLoading = false
    }
    
    // MARK: - 画像アップロード
    private func uploadImage(_ image: UIImage, userID: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw FirebaseError.imageConversionFailed
        }
        
        // ユニークなファイル名生成
        let filename = "\(UUID().uuidString).jpg"
        let storageRef = storage.reference().child("todo_images/\(userID)/\(filename)")
        
        // アップロード実行
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
        
        // ダウンロードURL取得
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL.absoluteString
    }
    
    // MARK: - Todo完了状態切り替え
    func toggleTodo(_ todo: FirebaseTodo) async {
        guard let todoID = todo.id else { return }
        
        do {
            var updatedTodo = todo
            updatedTodo.done.toggle()
            updatedTodo.updatedAt = Date()
            
            try db.collection("todos").document(todoID).setData(from: updatedTodo)
            await fetchTodos()
        } catch {
            self.errorMessage = "Todo의 갱신에 실패했습니다: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Todo削除
    func deleteTodo(_ todo: FirebaseTodo) async {
        guard let todoID = todo.id else { return }
        
        do {
            // Firestoreから削除
            try await db.collection("todos").document(todoID).delete()
            await fetchTodos()
        } catch {
            self.errorMessage = "Todo의 삭제에 실패했습니다: \(error.localizedDescription)"
        }
    }
}

// MARK: - エラー定義
enum FirebaseError: Error, LocalizedError {
    case imageConversionFailed
    case uploadFailed
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .imageConversionFailed:
            return "画像の変換に失敗しました"
        case .uploadFailed:
            return "アップロードに失敗しました"
        case .invalidData:
            return "無効なデータです"
        }
    }
}
