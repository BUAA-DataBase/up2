//
//  IndexView.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

struct IndexView: View {
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: 0xFF8D1A, alpha: 0.5))
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color(hex: 0xFFF5EB).ignoresSafeArea()
                
                VStack {
                    NavigationLink(destination: ImageUploadView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(hex: 0xFF8D1A, alpha: 0.5))
                                .frame(width: 300, height: 150)
                            HStack {
                                Text("Image Analyze")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                        }
                        .padding(7)
                    }
                    NavigationLink(destination: ImageGenerateView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(hex: 0xFF8D1A, alpha: 0.5))
                                .frame(width: 300, height: 150)
                            HStack {
                                Text("Image Generate")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                        }
                        .padding(7)
                    }
                }
            }
            .navigationBarTitle("UP2", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "carrot.fill")
                }
            }
        }
    }
}

#Preview {
    IndexView()
}
