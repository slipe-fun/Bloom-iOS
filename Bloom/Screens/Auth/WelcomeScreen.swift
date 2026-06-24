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
    
    var body: some View {
        VStack(alignment: .trailing) {
            WelcomeTitleView()
            WelcomeFooterView()
        }
    }
}
