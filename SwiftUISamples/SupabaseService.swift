import Foundation
import Supabase

// Supabaseサービスクラス
class SupabaseService {
    // Supabaseクライアントの初期化
    private static let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://vuvmnhhzcyheuaufxcbf.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1dm1uaGh6Y3loZXVhdWZ4Y2JmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MTU5NjMsImV4cCI6MjA2ODI5MTk2M30.xM24jTxJHa-FkKvtxScacUwuaWWDATLPsvD7vsshEX8"
    )

    // 画像をSupabase Storageにアップロードして公開URLを返す静的関数
    static func uploadImage(imageData: Data, fileName: String) async throws -> String {
        let path = "user123/\(fileName)"
        let bucket = "swiftui-samples"

        let fileOptions = FileOptions(
            cacheControl: "3600",
            upsert: true,
            contentType: "image/jpeg"
        )

        // 1. アップロード (この関数は非同期)
        try await supabase.storage
            .from(bucket)
            .upload(path: path, file: imageData, options: fileOptions)
        
        // 2. 公開URLを同期的に取得 (この関数は async ではない！)
        let publicURL = supabase.storage
            .from(bucket)
            .getPublicURL(path: path)

        print("✅ Supabaseへのアップロード成功！公開URL: \(publicURL.absoluteString)")
        
        // 3. 取得したURL文字列を返す
        return publicURL.absoluteString
    }
}
