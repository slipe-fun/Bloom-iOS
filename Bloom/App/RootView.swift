//
//  RootView.swift
//  Bloom
//
//  Created by Аскольд on 14.08.2026.
//

import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            switch appState.root {
            case .auth:
                AuthFlow()
                    .transition(
                        .opacity
                            .combined(with: .blur(radius: 10))
                    )

            case .main:
                ContentView()
                    .transition(
                        .opacity
                            .combined(with: .blur(radius: 10))
                    )
            }
        }
    }
}
