//
//  AuthFlow.swift
//  Bloom
//
//  Created by Аскольд on 14.08.2026.
//

import SwiftUI

struct AuthFlow: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            AuthWelcomeView()
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .mnemonic:
                        AuthMnemonicView()

                    case .success:
                        AuthSuccessView()
                    }
                }
        }
    }
}
