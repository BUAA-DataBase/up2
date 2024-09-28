//
//  EmptyBubble.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

struct EmptyBubble: View {
    @State var position: CGPoint!
    @State var text: Text!
    var body: some View {
        text
            .bold()
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 45)
                    .stroke(Color(hex: "F29B4C"), lineWidth: 2)
                    .fill(.white.opacity(0.6))
            )
            .position(position)
    }
}

#Preview {
    EmptyBubble(position: CGPoint(x: 112, y: 228))
}
