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
    @State private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environment(bottomSheetManager)
                .environment(router)
        }
    }
}
