//
//  CameraView.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import SwiftUI


struct CameraView: View {
    @StateObject private var model = DataModel()
    private static let barHeightFactorup = 0.1
    private static let barHeightFactorlow = 0.15
    @State private var tapPosition: CGPoint?
    @State private var isHighlighted: Bool = true
    @State private var showSuggest1: Bool = false
    @State private var showSuggest2: Bool = false
    @State private var showClass: Bool = false
    @State private var currentIndex1 = 0
    @State private var currentIndex2 = 0
    @State private var recognizeTime = 0
    @State private var scanning: Bool = true
    let bubbles = [
        (CGPoint(x: 100, y: 330.22), "临时洗衣桶"),
        (CGPoint(x: 91.69, y: 642.44), "收纳盒"),
        (CGPoint(x: 309.02, y: 629.22), "笔袋"),
        (CGPoint(x: 265.02, y: 304.22), "卡包"),
    ]
    let bubbles1 = [
        (CGPoint(x: 85.24, y: 175.29), "雨伞袋"),
        (CGPoint(x: 300.88, y: 226.28), "储物盒"),
        (CGPoint(x: 180.04, y: 155.22), "小花盆"),
        (CGPoint(x: 211.5, y: 682.22), "水杯套"),
        (CGPoint(x: 149.67, y: 251.45), "抽纸盒"),
    ]
    
    let bubbles2 = [
        (CGPoint(x: 207, y: 438), "小花盆"),
        (CGPoint(x: 120.69, y: 542.44), "笔筒"),
        (CGPoint(x: 309.02, y: 709.22), "工具架"),
        (CGPoint(x: 340.02, y: 324.22), "鸟食器"),
    ]
    let bubbles3 = [
        (CGPoint(x: 100, y: 682), "自制喷壶"),
        (CGPoint(x: 60, y: 400), "沙漏"),
        (CGPoint(x: 49, y: 256), "灯笼"),
        (CGPoint(x: 198, y: 232), "风铃"),
        (CGPoint(x: 234, y: 335), "收纳盒"),
    ]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    ViewfinderView(image:  $model.viewfinderImage )
                        .overlay(alignment: .top) {
                            upbuttonsView()
                                .frame(height: geometry.size.height * Self.barHeightFactorup)
                                .background(Color(hex: "FDBA75"))
                        }
                        .overlay(alignment: .bottom) {
                            buttonsView()
                                .frame(height: geometry.size.height * Self.barHeightFactorlow)
                                .background(Color(hex: "FDBA75"))
                                .padding(.top)
                        }
                        .overlay(alignment: .center)  {
                            Color.clear
                                .frame(height: geometry.size.height * (1 - (Self.barHeightFactorup + Self.barHeightFactorlow)))
                                .accessibilityElement()
                                .accessibilityLabel("View Finder")
                                .accessibilityAddTraits([.isImage])
                        }
                        .background(.black)
                    if showClass == true {
                        if recognizeTime == 1 {
                            FillBubble(position: tapPosition, text: Text("外卖保温袋"))
                        } else {
                            FillBubble(position: tapPosition, text: Text("塑料瓶"))
                        }
                    }
                    if showSuggest1 == true {
                        if recognizeTime == 1 {
                            ForEach(0..<min(currentIndex1, bubbles.count), id: \.self) { index in
                                EmptyBubble(position: bubbles[index].0, text: Text(bubbles[index].1))
                            }
                        } else {
                            ForEach(0..<min(currentIndex1, bubbles2.count), id: \.self) { index in
                                EmptyBubble(position: bubbles2[index].0, text: Text(bubbles2[index].1))
                            }
                        }
                    }
                    if showSuggest2 == true {
                        if recognizeTime == 1 {
                            ForEach(0..<min(currentIndex2, bubbles1.count), id: \.self) { index in
                                EmptyBubble(position: bubbles1[index].0, text: Text(bubbles1[index].1))
                            }
                        } else {
                            ForEach(0..<min(currentIndex2, bubbles3.count), id: \.self) { index in
                                EmptyBubble(position: bubbles3[index].0, text: Text(bubbles3[index].1))
                            }
                        }
                    }
                    if let tapPosition = tapPosition {
                        if scanning == true {
                            CameraFocus(show: true)
                                .position(tapPosition)
                        } else {
                            CameraFocus(show: false)
                                .position(tapPosition)
                        }
                    }
                }
                .onTapGesture { location in
                        tapPosition = location
                        isHighlighted = true
                        model.tapPosition = location
                        print("Tapped at: \(location) in width: \(geometry.size.width), height: \(geometry.size.height)")
                        model.ScreenWidth = geometry.size.width
                        model.ScreenHeight = geometry.size.height
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isHighlighted = false
                    }
                }
                
            }
            .task {
                await model.camera.start()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
    }
    
    private func upbuttonsView() -> some View {
        
        HStack(spacing: 60) {
            
            Spacer()
            
            
            NavigationBackButton(color: Color(hex: "FFF0C3"))
                .padding(.top)
            
            
            VStack {
                Spacer()
                CameraTitleView()
            }
            
            
            Image("Home")
                .resizable()
                .frame(width: 28, height: 40)
                .padding(.top)
            
            Spacer()
            
        }
        .labelStyle(.iconOnly)
        .padding()
        
    }
    
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            Button {
                self.scanning = true
                self.showClass = false
                self.showSuggest1 = false
                self.showSuggest2 = false
                self.currentIndex1 = 0
                self.currentIndex2 = 0
            } label: {
                RerecognizeButton()
                    .offset(x: 30, y: 5)
            }
                
            
            Button {
                model.camera.takePhoto()
                //tapPosition = nil
                self.scanning = false
                print(scanning)
                self.showClass = true
                self.showSuggest1 = true
                Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer in
                    if self.showSuggest1 && self.currentIndex1 < self.bubbles.count {
                        self.currentIndex1 += 1
                    } else {
                        timer.invalidate() // 停止计时器
                    }
                }
                recognizeTime += 1
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(Color(hex: 0xFFEFC0, alpha: 100), lineWidth: 3)
                            .frame(width: 75, height: 75)
                        Circle()
                            .fill(Color(hex: 0xFFEFC0, alpha: 100))
                            .frame(width: 60.94, height: 60.94)
                    }
                }
            }
            .offset(y: -10)
            
            Button {
                self.showSuggest2 = true
                Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer in
                    if self.showSuggest2 && self.currentIndex2 < self.bubbles1.count {
                        self.currentIndex2 += 1
                    } else {
                        timer.invalidate() // 停止计时器
                    }
                }
            } label: {
                MoreCreateButton()
                    .offset(x: -30, y: 5)
            }
            
            Spacer()
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
}
