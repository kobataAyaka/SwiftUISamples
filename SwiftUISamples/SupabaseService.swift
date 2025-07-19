import Foundation
import Supabase

// Supabaseクライアントの初期化
let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://vuvmnhhzcyheuaufxcbf.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1dm1uaGh6Y3loZXVhdWZ4Y2JmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MTU5NjMsImV4cCI6MjA2ODI5MTk2M30.xM24jTxJHa-FkKvtxScacUwuaWWDATLPsvD7vsshEX8"
)

// 画像をSupabase Storageにアップロードする関数
func uploadImageToSupabase(imageData: Data, fileName: String) async throws {
    let path = "user123/\(fileName)"
    let bucket = "photos"

    let fileOptions = FileOptions(
        cacheControl: "3600",
        upsert: true,
        contentType: "image/jpeg"
    )

    try await supabase.storage
        .from(bucket)
        .upload(path: path, file: imageData, options: fileOptions)

    print("✅ Supabaseへのアップロード成功！: \(path)")
}
