//
//  TextUploadView.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI


struct TextUploadView: View {
    @State var response: String = "none"
    var body: some View {
        VStack {
            Text("Response from OpenAI API:")
            Text(response)
            .padding()
            Button(action: {
                print("------------")
                // 创建消息和请求数据
                let requestData = OpenAIRequestData(
                    messages: [
                        Message(
                            role: "user",
                            content: [
                                MessageContent(
                                    type: "text",
                                    text: "What is the capital of China.")
                            ]
                        )
                    ],
                    model: "gpt-3.5-turbo"
                )

                let request = createUrlRequest(data: requestData)

                // 创建URLSession并发送请求
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    // 检查是否有错误
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }
                    
                    // 确保响应非空并且是HTTP响应
                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("Invalid response")
                        return
                    }
                    
                    // 打印HTTP状态码
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    
                    // 确保有响应数据
                    guard let data = data else {
                        print("No data")
                        return
                    }
                    
                    if let jsonString = String(data: data, encoding: .utf8) {
                            print("Raw JSON response: \(jsonString)")
                        }
                    
                    // 尝试解码响应数据
                    do {
                        let responseData = try JSONDecoder().decode(OpenAIAPIResponse.self, from: data)
                        // 处理解码后的数据
                        print("Response ID: \(responseData.id)")
                        print("Object: \(responseData.object)")
                        print("Created: \(responseData.created)")
                        for choice in responseData.choices {
                            print("Choice Index: \(choice.index)")
                            print("Choice Text: \(choice.message)")
                        }
                        print("Usage: \(responseData.usage)")
                        print("Prompt Tokens: \(responseData.usage.prompt_tokens)")
                        print("Completion Tokens: \(responseData.usage.completion_tokens)")
                        print("Total Tokens: \(responseData.usage.total_tokens)")
                        self.response = responseData.choices[0].message.content
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }

                // 启动请求任务
                task.resume()
            }){
                Text("Button")
            }
        }
    }
}

#Preview {
    TextUploadView()
}
