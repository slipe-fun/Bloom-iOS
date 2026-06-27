//
//  AvatarView.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

enum AvatarSize {
    case sm, md, lg, xl, xxl, xxxl, xxxxl
    
    var dimension: CGFloat {
        switch self {
        case .sm: return 40
        case .md: return 44
        case .lg: return 58
        case .xl: return 76
        case .xxl: return 100
        case .xxxl: return 128
        case .xxxxl: return 160
        }
    }
}

struct AvatarView: View {
    var size: AvatarSize = .md
    var square: Bool = false
    var image: String?
    var id: String = ""
    var name: String = ""
    
    private var dimension: CGFloat {
        size.dimension
    }
    
    var body: some View {
        Group {
            if let imageUrlString = image, let url = URL(string: imageUrlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let loadedImage):
                        loadedImage
                            .resizable()
                            .scaledToFill()
                    case .failure, .empty:
                        defaultAvatarView
                    @unknown default:
                        defaultAvatarView
                    }
                }
            } else {
                defaultAvatarView
            }
        }
        .frame(width: dimension, height: dimension)
        .cornerRadius(square ? 0 : dimension / 2)
    }
    
    private var defaultAvatarView: some View {
        let colors = avatarGradient(for: id)
        let initials = initials(from: name)
        
        return Circle()
            .fill(
                LinearGradient(
                    colors: colors,
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .overlay(
                Text(initials)
                    .font(Theme.font.bold(size: dimension / 2.25))
                    .foregroundStyle(Theme.colors.white)
            )
    }
}
