//
//  SettingsTestGooeyView.swift
//  Bloom
//
//  Created by Аскольд on 21.06.2026.
//

import SwiftUI

struct SettingsTestGooeyView: View {
    @State private var ballPosition: CGPoint = CGPoint(x: 200, y: 140)
        
        var body: some View {
            GeometryReader { geometry in
                AsyncImage(url: URL(string: "https://picsum.photos/800/800")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .colorEffect(
                                ShaderLibrary.gooeyShader(
                                    .float2(geometry.size.width / 2, 0),
                                    .float2(100, 30),
                                    .float(0),
                                    .float2(ballPosition),
                                    .float(50),
                                    .float(35.0)
                                )
                            )
                        
                    case .failure:
                        Color.clear
                            .overlay(Text("Err"))
                    @unknown default:
                        EmptyView()
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            ballPosition = value.location
                        }
                )
            }
            .ignoresSafeArea()
        }
}
