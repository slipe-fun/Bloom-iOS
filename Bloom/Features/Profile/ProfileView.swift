//
//  ProfileView.swift
//  Bloom
//
//  Created by Аскольд on 15.08.2026.
//

import SwiftUI

struct ProfileView: View {
    let id: Int
   

    var body: some View {
        VStack(spacing: 20) {
            AvatarView(
                size: .xxl,
                id: String(id),
                name: String(id)
            )
            .heroMatched(id: "user_avatar_transition\(id)", isSource: false)

            Text("Имя Пользователя")
                .font(.title2.bold())

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.inline)
    }
}
