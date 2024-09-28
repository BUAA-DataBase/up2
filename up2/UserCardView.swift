//
//  UserCardView.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI

struct UserCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(hex: 0xFF8D1A, alpha: 0.5))
                .frame(width: 350, height: 100)
            HStack {
                Circle()
                    .fill(.white)
                    .frame(width: 70, height: 70)
                VStack (alignment: .leading) {
                    Text("UserName")
                        .font(.custom("", size: 20))
                    Text("1233321")
                        .font(.custom("", size: 12))
                    HStack {
                        Button(action: {
                            
                        }) {
                            Text("Like")
                                .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                        Button(action: {
                            
                        }) {
                            Text("Like")
                                .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                        Button(action: {
                            
                        }) {
                            Text("Like")
                                .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                        Button(action: {
                            
                        }) {
                            Text("Like")
                                .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    UserCardView()
}
