//
//  WelcomeScreen.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI
import BlurSwiftUI

struct WelcomeScreen: View {
    @Environment(AppRouter.self) private var router
    
    @State private var shown: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .trailing) {
                WelcomeTitleView()
                WelcomeFooterView(shown: $shown)
            }
            .disabled(shown)
            .blur(radius: shown ? 10.0 : 0.0)
            .animation(.smooth, value: shown)
            .overlay{
                WelcomeSuccessGlowView(shown: $shown)
            }
        }
    }
}
