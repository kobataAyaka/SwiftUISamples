//
//  SupabaseManager.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 7/19/25.
//

import Supabase
import Foundation

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://vuvmnhhzcyheuaufxcbf.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1dm1uaGh6Y3loZXVhdWZ4Y2JmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MTU5NjMsImV4cCI6MjA2ODI5MTk2M30.xM24jTxJHa-FkKvtxScacUwuaWWDATLPsvD7vsshEX8"
)

func uploadImage(imageData: Data, fileName: String) async throws {
    let path = "user123/\(fileName)"
    let bucket = "swiftui-samples"

    try await supabase.storage
        .from(bucket)
        .upload(path, data: imageData, options: FileOptions(contentType: "image/jpeg", upsert: true))

    print("✅ アップロード成功！: \(path)")
}

struct TestTodo: Codable {
    let text: String
}

func addTestTodo(text: String) async throws {
    let todo = TestTodo(text: text)
    try await supabase.from("test_todos").insert(todo, returning: .minimal).execute()
    print("✅ テキストTodo追加成功！: \(text)")
}
