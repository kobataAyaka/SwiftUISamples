//
//  APIClient.swift
//  SwiftUISamples
//
//  Created by 小幡綾加 on 10/13/24.
//

import Alamofire
import SwiftUI
import ArkanaKeys

let mySecretAPIKey = ArkanaKeys.Global().mySecretAPIKey


class APIClient {
    
    @MainActor static let shared = APIClient() // シングルトンパターン
    
    func fetchTodos() async throws -> [Todo] {
        let url = "https://api.notion.com/v1/databases/11ebd71519e2807b9d99c61316da9757/query"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(mySecretAPIKey)",
            "Notion-Version": "2022-06-28"
        ]
        
        let parameters: [String: Any] = [
            "filter": [
                "property": "done",
                "checkbox": [
                    "equals": false
                ]
            ],
            "sorts": [
                [
                    "property": "name",
                    "direction": "descending"
                ]
            ]
        ]
        
        // Alamofire 5.5~ 추가된 async/await API
        let response = try await AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
            .serializingDecodable(NotionResponse.self)
            .value
        
        // NotionResponse 를 [Todo] 로 변환
        return response.results.compactMap { resultItem -> Todo? in
            let name = resultItem.properties.name.title.first?.plain_text ?? "No Name"
            let done = resultItem.properties.done.checkbox
            return Todo(name: name, done: done)
        }
        
        // Alamofire 5.5 이전이라면 이쪽을 사용
//        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[Todo], Error>) in
//            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//                .responseDecodable(of: NotionResponse.self) { response in
//                    switch response.result {
//                    case .success(let notionResponse):
//                        let todos = notionResponse.results.compactMap { resultItem -> Todo? in
//                            let name = resultItem.properties.name.title.first?.plain_text ?? "No Name"
//                            let done = resultItem.properties.done.checkbox
//                            return Todo(name: name, done: done)
//                        }
//                        continuation.resume(returning: todos)
//                    case .failure(let error):
//                        continuation.resume(throwing: error)
//                    }
//                }
//        }

    }
}

struct NotionResponse: Codable {
    let results: [NotionPage]
}

struct NotionPage: Codable {
    let id: String
    let properties: Properties
}

struct Properties: Codable {
    let name: Name
    let done: Done
    
    struct Name: Codable {
        let title: [Title]
        
        struct Title: Codable {
            let plain_text: String
        }
    }
    
    struct Done: Codable {
        let checkbox: Bool
    }
}
