//
//  FillBubble.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

struct FillBubble: View {
    @State var fontSize: CGFloat = 20.0
    @State var textSize: CGSize = .zero
    @State var position: CGPoint!
    @State var text: Text!
    var body: some View {
        text
            .bold()
            .padding()
            .font(.system(size: fontSize))
            .background(Rectangle()
                .fill(Color(hex: "EBB79B"))
                .cornerRadius(20))
            .position(position)
            
    }
    
}

#Preview {
    FillBubble(position: CGPoint(x: 227, y: 333), text: Text("保温袋"))
}
