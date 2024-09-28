//
//  OpenAiRequestApi.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation

// Request Struct
struct OpenAIRequestData: Codable {
    let messages: [Message]
    let model: String
    var max_tokens: Int = 300
}

struct Message: Codable {
    let role: String
    let content: [MessageContent]
}

struct MessageContent: Codable {
    let type: String
    var text: String? = nil
    var image_url: ImageUrlContent? = nil
    var resize: Int? = nil
}

struct ImageUrlContent: Codable {
    let url: String
}

// Response Struct
struct OpenAIAPIResponse: Codable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }

    let id: String
    var object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
}

struct ResponseMessage: Codable{
    let role: String
    let content: String
}

struct Choice: Codable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    
    let index: Int
    let message: ResponseMessage
    let finish_reason: String
}

struct Usage: Codable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
}

// DALL-E requeset struct
struct DalleRequest: Codable {
    var model: String = "dall-e-3"
    let prompt: String
    var n: Int = 1
    var size: String = "1024x1024"
}

struct DalleResponse: Codable {
    let created: Int
    let data: [DalleData]
}

struct DalleData: Codable {
    let revised_prompt: String
    let url: String
}

let OPENAI_API_URL = "https://fast.bemore.lol/v1/chat/completions"
let DALLE_API_URL = "https://fast.bemore.lol/v1/images/generations"
let API_KEY = "sk-4tBuAd19CsauY8PrF1521fD5E9164bE5BaD1B66e250566Ad"

func createUrlRequest(data: Codable, apiUrl: String = OPENAI_API_URL) -> URLRequest {
    // 将请求数据编码为JSON
    guard let jsonData = try? JSONEncoder().encode(data) else {
        fatalError("Error encoding JSON data")
    }
    // 创建URL对象
    guard let url = URL(string: apiUrl) else {
        fatalError("Invalid URL")
    }
    // 创建URL请求对象
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(API_KEY)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    return request
}

