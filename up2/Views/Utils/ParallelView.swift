//
//  ParallelView.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

// 斜条组件 —— 用于StartView
struct ParallelView: View {
    var topleft: CGFloat
    var topright: CGFloat
    var distance: CGFloat
    var color1: Color
    var color2: Color
    var text: String
    var textAlignment: TextAlignment
    var font: Font
    var isBold: Bool
    
    init(topleft: CGFloat, topright: CGFloat, distance: CGFloat, color1: Color, color2: Color, text: String, textAlignment: TextAlignment, font: Font, isBold: Bool) {
            self.topleft = topleft
            self.topright = topright
            self.distance = distance
            self.color1 = color1
            self.color2 = color2
            self.text = text
            self.textAlignment = textAlignment
            self.font = font
            self.isBold = isBold
        }
    

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width // 393.00
            let topleft = self.topleft
            let distance = self.distance
            let slope = (topright - topleft) / screenWidth
            let angle = atan(slope) * 180 / .pi
            
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: topleft))  // 左上角
                    path.addLine(to: CGPoint(x: screenWidth, y: topright))  // 右上角
                    path.addLine(to: CGPoint(x: screenWidth, y: topright - distance))  // 右下角
                    path.addLine(to: CGPoint(x: 0, y: topleft - distance))  // 左下角
                    path.closeSubpath()
                }
                .fill(LinearGradient(
                    gradient: Gradient(colors: [color1, color2]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                
                Text(createAttributedString(from: text))
                    .font(isBold ? font.bold() : font)
                    .foregroundStyle(.black)
                    .rotationEffect(.degrees(Double(angle)))
                    .frame(width: screenWidth, alignment: alignment(for: textAlignment))
                    .position(x: screenWidth / 2, y: (topleft + topright - distance) / 2)
            }
        }
    }
    
    // 对给定的正则表达式匹配字符特殊处理 —— up和to
    private func createAttributedString(from text: String) -> AttributedString {
            var attributedString = AttributedString(text)
            let patterns = ["up", "\\bto\\b"]
            for pattern in patterns {
                if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                    let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)
                    let matches = regex.matches(in: text, options: [], range: nsRange)
                    for match in matches {
                        if let range = Range(match.range, in: text) {
                            let lowerBound = AttributedString.Index(range.lowerBound, within: attributedString)
                            let upperBound = AttributedString.Index(range.upperBound, within: attributedString)
                            attributedString[lowerBound!..<upperBound!].font = .system(size: 24, weight: .bold)
                            attributedString[lowerBound!..<upperBound!].foregroundColor = Color(hex: "F0841F")
                        }
                    }
                }
            }
            return attributedString
        }
    
    // 解析参数
    private func alignment(for textAlignment: TextAlignment) -> Alignment {
            switch textAlignment {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .center:
                return .center
            }
        }
}

struct TextUnit: View {
    var body: some View {
        ParallelView(
            topleft: 180,
            topright: 90,
            distance: 100,
            color1: .yellow.opacity(0.2),
            color2: .orange,
            text: "UP to you!\nup",
            textAlignment: .center,
            font: .title2,
            isBold: true
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct TextUnit_Previews: PreviewProvider {
    static var previews: some View {
        TextUnit()
    }
}
