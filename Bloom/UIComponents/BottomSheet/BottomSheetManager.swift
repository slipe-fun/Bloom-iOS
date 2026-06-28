//
//  BottomSheetManager.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI
import Observation

enum SheetState {
    case hidden
    case collapsed
    case expanded
}

@MainActor
@Observable
final class BottomSheetManager {
    var state: SheetState = .hidden
    var content: AnyView? = nil
    var scrollOffset: CGFloat = 0
    
    func present<Content: View>(@ViewBuilder content: () -> Content) {
        self.state = .hidden
        self.content = AnyView(content())
        self.scrollOffset = 0
        
        Task { @MainActor in
            withAnimation(.normalSpring) {
                self.state = .collapsed
            }
        }
    }
    
    func dismiss() {
        withAnimation(.normalSpring) {
            self.state = .hidden
        }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.35))
            
            if self.state == .hidden {
                self.content = nil
            }
        }
    }
}
