//
//  NavigationBackButton.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

struct NavigationBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    var color: Color = .black
    
    var body: some View {
        Image(systemName: "chevron.left")
            .foregroundColor(color)
            .font(.system(size: 40, weight: .bold))
            .onTapGesture {
                self.presentationMode.wrappedValue.dismiss()
            }
    }
}

struct DIYBackButton<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    
    let content: Content
    var action: () -> () = {}

    init(action: @escaping ()->() = {}, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.action = action
    }

    
    var body: some View {
        content
            .onTapGesture {
                self.action()
                self.presentationMode.wrappedValue.dismiss()
            }
    }
}

#Preview {
    NavigationBackButton(color: .black)
}
