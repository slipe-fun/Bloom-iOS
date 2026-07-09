//
//  ChatMediaSheetEmptyView.swift
//  Bloom
//
//  Created by Аскольд on 09.07.2026.
//

import SwiftUI
import Photos

enum EmptyMorphState: String, CaseIterable, Identifiable {
    case image = "image_icon"
    case file = "file_icon"
    case camera = "camera_icon"
    
    var id: String { self.rawValue }
}

struct ChatMediaSheetEmptyView: View {
    @Environment(\.customSafeArea) private var safeArea
    @Environment(\.openURL) private var openURL
    @State private var currentState: EmptyMorphState = .image
    @State private var lastInteractionDate = Date()
    @ObservedObject var manager: PhotoLibraryManager
    
    private func selectNextState() {
        let allStates = EmptyMorphState.allCases
        if let currentIndex = allStates.firstIndex(of: currentState) {
            let nextIndex = (currentIndex + 1) % allStates.count
            currentState = allStates[nextIndex]
        }
    }
    
    private func handleTap() {
        selectNextState()
        
        lastInteractionDate = Date()
    }
    
    private var statusTitle: String {
        let text = switch manager.permissionStatus {
        case .notDetermined:
            "Access to gallery & camera"
            
        case .restricted:
            "Access to gallery restricted"
            
        case .denied:
            "Access to gallery denied"
            
        case .authorized:
            ""
            
        case .limited:
            ""
            
        @unknown default:
            "Unknown permission status"
        }
        return text
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: Theme.spacing.lg) {
            DashedBoxView(width: 105, height: 105, borderRadius: Theme.radius.xl, dashLength: 10, color: Theme.colors.switcher) {
                MorphingView(currentID: currentState) { state in
                    IconView(name: state.rawValue, size: 70, color: Theme.colors.switcher)
                }
                .frame(width: 100, height: 100)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                handleTap()
            }
            
            VStack(alignment: .center, spacing: Theme.spacing.sm) {
                Text(statusTitle)
                    .font(Theme.font.title2Thinner)
                    .foregroundStyle(Theme.colors.text)
                
                Text("You'll be able to send photos and videos up to 100 MB in size")
                    .font(Theme.font.body)
                    .foregroundStyle(Theme.colors.secondaryText)
                    .tint(Theme.colors.primary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            } label: {
                Text("Open settings")
                    .font(Theme.font.button)
                    .foregroundStyle(Theme.colors.white)
            }
            .padding(.horizontal, Theme.spacing.xxxl + 24)
            .buttonStyle(.plain)
            .frame(height: 52)
            .glassEffect(.regular.interactive().tint(Theme.colors.primary))
        }
        .padding(.horizontal, Theme.spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.blur(radius: 8).combined(with: .opacity).combined(with: .scale(scale: 0.9)))
        .task(id: lastInteractionDate) {
            do {
                try await Task.sleep(for: .seconds(3))
                
                selectNextState()
                
                lastInteractionDate = Date()
            } catch {
                
            }
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            ChatMediaSheetHeaderView(manager: manager)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ChatMediaSheetFooterView()
        }
    }
}
