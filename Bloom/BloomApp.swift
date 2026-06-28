//
//  BloomApp.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

@main
struct BloomApp: App {
    @State private var bottomSheetManager = BottomSheetManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                AppCoordinatorView()
                
                GlobalBottomSheetOverlayView()
            }
            .environment(bottomSheetManager)
        }
    }
}
