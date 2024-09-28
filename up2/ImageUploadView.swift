//
//  ImageUploadView.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

struct ImageUploadView: View {
    @State private var selectedImage: UIImage = UIImage(named: "Sample_image2")!
    @State private var isImagePickerPresented = false
    @State private var detectedRect: CGRect = .zero
    @State private var locate: CGPoint = .zero
    @State private var newimage: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(.red)
                VStack {
                    //if let image = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            //.frame(width: 300, height: 300)
    //                        .overlay(
    //                            Rectangle()
    //                                .stroke(Color.red, lineWidth: 2)
    //                                .frame(width: detectedRect.width, height: detectedRect.height)
    //                                .position(x: locate.x, y: locate.y)
    //                        )
                            .onTapGesture { location in
                                let convertedPoint = convertToImageCoordinates(location, in: geometry.size)
                                locate = convertedPoint
                                //detectedRect = CGRect(origin: locate, size: CGSize(width: 2, height: 2))
                                selectedImage = imageWithX(on: selectedImage, at: locate)
                            }
    //                } else {
    //                    Text("Select an image")
    //                        .padding()
    //                }
                    Text("\(locate)")
    //                Button(action: {
    //                    isImagePickerPresented.toggle()
    //                }) {
    //                    Text("Pick an image")
    //                        .padding()
    //                        .background(Color.blue)
    //                        .foregroundColor(.white)
    //                        .cornerRadius(8)
    //                }
    //                .sheet(isPresented: $isImagePickerPresented) {
    //                    ImagePicker(selectedImage: $selectedImage)
    //                }
                    
                    
                    Button(action: {
                        print("------------")
                        // 创建消息和请求数据
                        let base64img = convertImageToBase64String(img: selectedImage, targetSize: CGSize(width: 224, height: 224))
                        //Remove !
                        if base64img == nil {
                            print("invalid image")
                            return
                        }
                        let requestData = OpenAIRequestData(
                            messages: [
                                Message(
                                    role: "user",
                                    content: [
                                        MessageContent(
                                            type: "text",
                                            text:
                                            "图中有一个红色的x，这个x的中心点所在的物体是什么？这个物体是一种废品，请问是什么废品，请简要回答我，不需要任何的描述"),
                                        MessageContent(
                                            type: "image_url",
                                            image_url: ImageUrlContent(
                                                url: "data:image/jpeg;base64,\(base64img!)"),
                                            resize: 768)
                                    ]
                                )
                            ],
                            model: "gpt-4-vision-preview"
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
                            } catch {
                                print("Error decoding JSON: \(error)")
                            }
                        }
                        
                        // 启动请求任务
                        task.resume()
                    }){
                        Text("send")
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
        
        
        func convertToImageCoordinates(_ point: CGPoint, in viewSize: CGSize) -> CGPoint {
                //if let image = selectedImage {
                    guard let cgImage = selectedImage.cgImage else { return point }
                    
                    let imageViewRatio = selectedImage.size.width / selectedImage.size.height
                    let viewRatio = viewSize.width / viewSize.height
                    
                    var scaleFactor: CGFloat
                    var scaledImageSize: CGSize
                    
                    if imageViewRatio > viewRatio {
                        scaleFactor = viewSize.width / selectedImage.size.width
                        scaledImageSize = CGSize(width: viewSize.width, height: selectedImage.size.height * scaleFactor)
                    } else {
                        scaleFactor = viewSize.height / selectedImage.size.height
                        scaledImageSize = CGSize(width: selectedImage.size.width * scaleFactor, height: viewSize.height)
                    }
                    
                    let imageOrigin = CGPoint(
                        x: (viewSize.width - scaledImageSize.width) / 2,
                        y: (viewSize.height - scaledImageSize.height) / 2
                    )
                    
                    let convertedX = (point.x) / scaleFactor
                    let convertedY = (point.y) / scaleFactor
                    
                    return CGPoint(x: convertedX, y: convertedY)
                //}
                //return CGPoint(x: 0, y: 0)
            }
        
        func imageWithX(on image: UIImage, at point: CGPoint) -> UIImage {
                // 开始图形上下文
                UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
                let context = UIGraphicsGetCurrentContext()
                
                // 绘制原始图像
                image.draw(at: CGPoint.zero)
                
                // 设置 X 的颜色和线宽
                context?.setStrokeColor(UIColor.red.cgColor)
                context?.setLineWidth(5.0)
                
                // 计算 X 的两条线的端点
                let xLength: CGFloat = 30.0
                let startX1 = CGPoint(x: point.x - xLength / 2, y: point.y - xLength / 2)
                let endX1 = CGPoint(x: point.x + xLength / 2, y: point.y + xLength / 2)
                let startX2 = CGPoint(x: point.x + xLength / 2, y: point.y - xLength / 2)
                let endX2 = CGPoint(x: point.x - xLength / 2, y: point.y + xLength / 2)
                
                // 绘制 X 的两条线
                context?.move(to: startX1)
                context?.addLine(to: endX1)
                context?.move(to: startX2)
                context?.addLine(to: endX2)
                context?.strokePath()
                
                // 获取新图像
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return newImage ?? image
            }
    
}

#Preview {
    ImageUploadView()
}
