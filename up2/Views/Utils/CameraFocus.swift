//
//  CameraFocus.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

struct CameraFocus: View {
    @State private var sliderPosition: CGFloat = 0
    @State var show: Bool
    let animationDuration: Double = 2.0

    var body: some View {
        ZStack {
            Image("cameraFocus")
                .resizable()
                .frame(width: 186, height: 206)

            if show == true {
                Image("cameraFocusBar")
                    .resizable()
                    .frame(width: 170, height: 20) // 条的高度
                    .offset(y: sliderPosition - 103)
                    .onAppear {
                        withAnimation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                            sliderPosition = 190 // 设置条的最大偏移量（框的高度的一半）
                        }
                    }
            }
        }
    }
}

#Preview {
    CameraFocus(show: true)
}



