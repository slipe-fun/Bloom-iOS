//
//  GlobalBottomSheetOverlayView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct GlobalBottomSheetOverlayView: View {
    @Environment(BottomSheetManager.self) private var manager
    @Environment(\.customSafeArea) private var safeAreaInsets
    
    var body: some View {
        GeometryReader { proxy in
            let screenWidth = proxy.size.width + safeAreaInsets.leading + safeAreaInsets.trailing
            let screenHeight = proxy.size.height
            let screenSize = CGSize(width: screenWidth, height: screenHeight)
            
            ZStack(alignment: .top) {
                if manager.state != .hidden {
                    Theme.colors.black
                        .opacity(0.2)
                        .onTapGesture {
                            manager.dismiss()
                        }
                        .transition(.opacity)
                }
                
                if let content = manager.content {
                    @Bindable var bindableManager = manager
                    
                    CustomBottomSheetContainerView(
                        manager: bindableManager,
                        screenSize: screenSize,
                        safeAreaInsets: safeAreaInsets
                    ) {
                        content
                    }
                }
            }
            .animation(.normalSpring, value: manager.state)
        }
        .ignoresSafeArea()
    }
}
