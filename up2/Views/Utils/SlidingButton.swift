//
//  SkidingButton.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

// 透明背景
struct BackgroundComponent: View {
    
    let width: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading)  {
            RoundedRectangle(cornerRadius: 45)
                .fill(Color.clear)
                .stroke(Color(hex: "F0841F").opacity(0.2), lineWidth: 5)
                .frame(width: width)

        }
        
    }

}

// 拖拽部分
struct DraggingComponent: View {
    
    
    var maxWidth: CGFloat
    private let minWidth = CGFloat(85)
    @State private var width = CGFloat(85)
    // 这个变量是界定是否完成滑动解锁的变量，但没测试过
    @Binding var isunLocked: Bool
    @State private var showArrow1 = false
    @State private var showArrow2 = false
    @State private var showArrow3 = false
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 45)
                .fill(Color.clear)
                .frame(width: width)
                .overlay(
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(colors:[Color(hex: "FFD980"), Color(hex: "FC9E4C")], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .overlay(
                                Image("SlideButton")
                                .resizable()
                                .scaledToFit()
                                .padding(2)
                            )
                            .padding(2.7)
                            .offset(x: 18) // 初始时离左边框一定距离
                    },
                    alignment: .trailing
                  )
              .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !isunLocked else { return }
                        if value.translation.width > 0 {
                            width = min(max(value.translation.width + minWidth, minWidth), maxWidth - 18)
                            showArrow1 = false
                            showArrow2 = false
                            showArrow3 = false
                        }
                    }
                    .onEnded { value in
                        guard !isunLocked else { return }
                        if width < maxWidth - 18 {
                            width = minWidth
                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                            showArrow1 = true
                            showArrow2 = true
                            showArrow3 = true
                            print("not ready unlock")
                        } else {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            withAnimation(.spring().delay(0.5)) {
                            isunLocked = true
                            print("unlock")
                        }
                      }
                    }
              )
          .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0), value: width)
            
            HStack(spacing: -10) {
                arrow(isShown: $showArrow1, color: Color(hex: "FFC300"))
                arrow(isShown: $showArrow2, color: Color(hex: "FFAA00"))
                arrow(isShown: $showArrow3, color: Color(hex: "FF8D1A"))
            }
            //.padding(.leading, 5)
            .onAppear {
                startArrowAnimations()
            }
            .offset(x: 10)
        }
          
      }
    
    // 箭头闪动
    private func startArrowAnimations() {
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.1)) {
                showArrow1 = true
            }
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.3)) {
                showArrow2 = true
            }
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.5)) {
                showArrow3 = true
            }
        }
    
    // 箭头
    private func arrow(isShown: Binding<Bool>, color: Color) -> some View {
            Image(systemName: "chevron.right")
            .font(.system(size: 30, weight: .bold))
                .foregroundColor(color)
                .opacity(isShown.wrappedValue ? 1 : 0)
        }
}

struct SlidingButton: View {
    
    @Binding var isunLocked: Bool
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                BackgroundComponent(width: width)
                DraggingComponent(maxWidth: width, isunLocked: $isunLocked)
            }
        }
        .frame(height: height)
        .padding()
        // 凑的
        .rotationEffect(.degrees(-12.6))
    }

}

//#Preview {
////    SlidingButton(isLocked: true, width: 304, height: 85)
//}
