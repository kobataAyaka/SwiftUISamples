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
    
    static let shared = APIClient() // シングルトンパターン
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
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
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: NotionResponse.self) { response in
                switch response.result {
                case .success(let notionResponse):
                    let todos = notionResponse.results.compactMap { resultItem -> Todo? in
                        let name = resultItem.properties.name.title.first?.plain_text ?? "No Name"
                        let done = resultItem.properties.done.checkbox
                        return Todo(name: name, done: done)
                    }
                    completion(.success(todos))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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
