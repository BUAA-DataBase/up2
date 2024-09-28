//
//  DataModel.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import AVFoundation
import SwiftUI
import Vision
import os.log

final class DataModel: ObservableObject {
    @Published var camera: Camera = Camera()
    @Published var tapPosition: CGPoint?
    @Published var viewfinderImage: Image?
    @Published var thumbnailImage: Image?
    @Published var nowImage: CGImage?
    @Published var ScreenWidth: CGFloat = CGFloat.zero
    @Published var ScreenHeight: CGFloat = CGFloat.zero
    
    
    
    init() {
        Task {
            // 等待图片流，从camera传输过来的image，存储在viewfinderImage变量里面
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }

        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                nowImage = photoData
            }
        }
    }
    
            
    private func DrawXinPhoto(image: CGImage?) -> CGImage? {
        if let image = image {
            let width = image.width
            let height = image.height
            print("width: \(width)")
            print("height: \(height)")
            let size = CGSize(width: width, height: height)
            
            // 创建图像上下文
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let context = CGContext(data: nil,
                                          width: width,
                                          height: height,
                                          bitsPerComponent: 8,
                                          bytesPerRow: 0,
                                          space: colorSpace,
                                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
                return nil
            }
            
            // 在上下文中绘制原始图像
            context.draw(image, in: CGRect(origin: .zero, size: size))
            
            // 设置 "X" 的绘制参数
            let xColor = UIColor.red.cgColor
            let lineWidth: CGFloat = 5
            let xSize: CGFloat = CGFloat(min(width, height)) * 0.1 // X 的大小是图像的 10%
            let rate = CGFloat(width)/ScreenHeight
            let yOffset = (CGFloat(height) - ScreenWidth) / 2
            // 计算 "X" 的位置
            let centerX = (tapPosition?.y ?? CGFloat(width/2)) * rate
            let centerY = (tapPosition?.x ?? CGFloat(height/2)) * rate + yOffset
            print("x \(centerX)")
            print("y \(centerY)")
            
            // 绘制 "X"
            context.setStrokeColor(xColor)
            context.setLineWidth(lineWidth)
            
            context.move(to: CGPoint(x: centerX - xSize / 2, y: centerY - xSize / 2))
            context.addLine(to: CGPoint(x: centerX + xSize / 2, y: centerY + xSize / 2))
            
            context.move(to: CGPoint(x: centerX + xSize / 2, y: centerY - xSize / 2))
            context.addLine(to: CGPoint(x: centerX - xSize / 2, y: centerY + xSize / 2))
            
            context.strokePath()
            
            // 从上下文中获取新的 CGImage
            return context.makeImage()
        } else {
            return nil
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> CGImage? {
        guard let rawImage = photo.previewCGImageRepresentation() else { return nil }
        return DrawXinPhoto(image: rawImage)
    }
}


fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "DataModel")
