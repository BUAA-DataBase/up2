//
//  StartView.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

// 待优化：字体，

struct UpcyclingView: View {
    @State private var isunLocked: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                ParallelView(
                    topleft: 90,
                    topright: 0,
                    distance: 120/cos(.pi/12),
                    color1: Color(hex: "FEF3E2"),
                    color2: Color(hex: ""),
                    text: "FFF8E8",
                    textAlignment: .center,
                    font: .title2,
                    isBold: false
                )
                
                ParallelView(
                    topleft: 115,
                    topright: 25,
                    distance: 120/cos(.pi/12),
                    color1: Color(hex: "FFFAF0"),
                    color2: Color(hex: "FBE2C4"),
                    text: "Upcycling to storage boxes",
                    textAlignment: .center,
                    font: .title2,
                    isBold: false
                )
                
                ParallelView(
                    topleft: 140,
                    topright: 50,
                    distance: 120/cos(.pi/12),
                    color1: Color(hex: "FEF4E5"),
                    color2: Color(hex: "FFFCF1"),
                    text: "     Upcycling to photo frame\n\n                            Upcycling to art painting",
                    textAlignment: .leading,
                    font: .title2,
                    isBold: false
                )
                
                ParallelView(
                    topleft: 165,
                    topright: 75,
                    distance: 120/cos(.pi/12),
                    color1: Color(hex: "FFFCF5"),
                    color2: Color(hex: "FDE8CE"),
                    text: "         Upcycling to all kinds of practical \n                              goodies......",
                    textAlignment: .leading,
                    font: .title2,
                    isBold: false
                )
                
                ParallelView(
                    topleft: 190,
                    topright: 100,
                    distance: 120/cos(.pi/12),
                    color1: Color(hex: "FFF7E6"),
                    color2: Color(hex: "FFF5D8"),
                    text: "It's just up to you",
                    textAlignment: .center,
                    font: .title2,
                    isBold: true
                )
                
                
                ZStack {
                    ParallelView(
                        topleft: 215,
                        topright: 125,
                        distance: 120/cos(.pi/12),
                        color1: Color(hex: "FFFBF2"),
                        color2: Color(hex: "FDECD1"),
                        text: "",
                        textAlignment: .center,
                        font: .title2,
                        isBold: true
                    )
                    SlidingButton(isunLocked: $isunLocked, width: 304, height: 85)
                        .offset(x: 25, y: 45)
                }
                
                
                ParallelView(
                    topleft: 240,
                    topright: 150,
                    distance: 120/cos(.pi/12),
                    color1: Color(hex: "FEF7F0"),
                    color2: Color(hex: "FEF8EA"),
                    text: "",
                    textAlignment: .center,
                    font: .title2,
                    isBold: true
                )
            }
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(isPresented: $isunLocked) {
                CameraView()
            }
        }
    }
}


struct UpcyclingView_Previews: PreviewProvider {
    static var previews: some View {
        UpcyclingView()
    }
}

