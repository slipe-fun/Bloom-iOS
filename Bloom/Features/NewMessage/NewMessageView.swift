//
//  NewMessageView.swift
//  Bloom
//
//  Created by Аскольд on 12.08.2026.
//

import SwiftUI

struct NewMessageView: View {
    @Environment(\.heroNamespace) private var namespace
    @Environment(Router.self) private var router

    var body: some View {
        NavigationStack {
            List {
                ForEach(1...20, id: \.self) { id in
                    NewMessageRowView(userId: id)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollEdgeEffectHidden(true, for: .all)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New message")
                        .font(.system(.headline, design: .rounded))
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        router.dismissModal()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .controlSize(.regular)
                }
            }
            .topVariableBlur()
            .bottomSafeAreaGradient()
        }
        .navigationTransition(.zoom(sourceID: "newMessageButton", in: namespace!))
    }
}
