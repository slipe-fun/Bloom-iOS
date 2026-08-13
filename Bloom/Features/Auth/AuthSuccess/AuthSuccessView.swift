//
//  AuthSuccessView.swift
//  Bloom
//
//  Created by Аскольд on 14.08.2026.
//

import SwiftUI

struct AuthSuccessView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 72))

            Text("Welcome back!")
                .font(.title2.bold())

            Spacer()

            Button("Continue to chats") {
                appState.authenticate()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding(24)
        .toolbar(.hidden, for: .navigationBar)
    }
}
