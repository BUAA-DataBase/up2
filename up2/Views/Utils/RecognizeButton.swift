//
//  RecognizeButton.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

struct RerecognizeButton: View {
    var body: some View {
            ZStack {
                
                RoundedRectangle(cornerRadius: 45)
                    .fill(
                        LinearGradient(colors: [Color(hex: 0xFDBD79, alpha: 100), Color(hex: 0xFFEAAC, alpha: 100)], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: 130, height: 50)
                HStack(spacing: 1) {
                    Image("Reget")
                        .resizable()
                        .frame(width: 30,
                        height: 30)
                    Text("重新识别")
                        .foregroundStyle(.black)
                }
            }
    }
}

#Preview {
    RerecognizeButton()
}
