//
//  MoreCreateButton.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

struct MoreCreateButton: View {
    var body: some View {
            ZStack {
                
                RoundedRectangle(cornerRadius: 45)
                    .fill(
                        LinearGradient(colors: [Color(hex: 0xFFEAAC, alpha: 100),Color(hex: 0xFDBD79, alpha: 100) ], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: 130, height: 50)
                HStack(spacing: 1) {
                    Text("更多创意")
                        .foregroundStyle(.black)
                    Image("MoreCreateButton")
                        .resizable()
                        .frame(width: 30,
                        height: 30)
                    
                }
            }
        
    }
}

#Preview {
    MoreCreateButton()
}
