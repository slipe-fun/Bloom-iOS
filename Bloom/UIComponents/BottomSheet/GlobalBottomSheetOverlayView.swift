//
//  GlobalBottomSheetOverlayView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct GlobalBottomSheetOverlayView: View {
    @Environment(BottomSheetManager.self) private var manager
    
    var body: some View {
        GeometryReader { proxy in
            let screenSize = proxy.size
            
            ZStack(alignment: .top) {
                if manager.state != .hidden {
                    Color.black
                        .opacity(0.15)
                        .ignoresSafeArea()
                        .onTapGesture {
                            manager.dismiss()
                        }
                        .transition(.opacity)
                }
                
                if let content = manager.content {
                    @Bindable var bindableManager = manager
                    
                    CustomBottomSheetContainerView(
                        manager: bindableManager,
                        screenSize: screenSize
                    ) {
                        content
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .animation(.normalSpring, value: manager.state)
        }
    }
}
