//
//  SettingsView.swift
//  Bloom
//
//  Created by Аскольд on 13.08.2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(Router.self) private var router
    @Environment(AppState.self) private var appState
    @Environment(BloomManager.self) private var bloomManager

    var body: some View {
        List {
                        Section {
                            Button(role: .destructive) {
                                bloomManager.logout()
                                
                                router.dismissModal()
                                
                                appState.logout()
                            } label: {
                                Label("Log Out", systemImage: "arrow.left.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }


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
                    Text("Nicolas Cage")
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
    }
}
