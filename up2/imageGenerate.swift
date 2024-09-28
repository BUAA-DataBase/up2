//
//  imageGenerate.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

struct ImageGenerateView: View {
    @State private var imageUrl = URL(string: "https://example.com/image.jpg")
    @State private var gabbage: String = "塑料瓶"
    var body: some View {
        VStack {
            if let url = imageUrl {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .foregroundColor(.gray)
                        Text("fail")
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Text("Invalid URL")
            }
            Button(action: {
                let requestData = DalleRequest(prompt: "生成一个用\(gabbage)变废为宝的案例")
                let request = createUrlRequest(data: requestData, apiUrl: DALLE_API_URL)
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
                        let responseData = try JSONDecoder().decode(DalleResponse.self, from: data)
                        imageUrl = URL(string: responseData.data[0].url)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }

                // 启动请求任务
                task.resume()
            }) {
                Text("gen")
            }
        }
        .navigationBarTitle("Image Generation", displayMode: .inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "carrot.fill")
            }
        }
    }
}

//#Preview {
//    ImageGenerateView()
//}
