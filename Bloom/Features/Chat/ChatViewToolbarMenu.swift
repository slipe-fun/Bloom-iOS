//
//  ChatViewToolbarMenu.swift
//  Bloom
//
//  Created by Аскольд on 15.08.2026.
//

import SwiftUI

struct ChatViewToolbarMenu: View {
    var body: some View {
        Menu {
            Section {
                Button {
                    print("call")
                } label: {
                    Label("Start call", systemImage: "phone.fill")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                }
                
                Button {
                    print("pin")
                } label: {
                    Label("Pin chat", systemImage: "pin.fill")
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
            }
            
            Section {
                Button {
                    print("mute")
                } label: {
                    Label("Mute", systemImage: "speaker.slash.fill")
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
                
                Button {
                    print("disable screenshots")
                } label: {
                    Label("Disable screenshots", systemImage: "eye.slash.fill")
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
            }
            
            Section {
                Button(role: .destructive) {
                    print("clear messages")
                } label: {
                    Label("Clear messages", systemImage: "trash.fill")
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
                
                Button(role: .destructive) {
                    print("block user")
                } label: {
                    Label("Block user", systemImage: "person.crop.circle.badge.xmark")
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}
