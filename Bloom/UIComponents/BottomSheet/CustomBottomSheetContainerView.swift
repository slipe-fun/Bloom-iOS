//
//  CustomBottomSheetContainerView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct CustomBottomSheetContainerView<Content: View>: View {
    @Bindable var manager: BottomSheetManager
    let screenSize: CGSize
    let safeAreaInsets: EdgeInsets
    @ViewBuilder let content: Content
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDraggingSheet: Bool = false
    @State private var dragStartTranslation: CGFloat = 0
    
    private var collapsedHeight: CGFloat = 450
    private var sheetSpace: CGFloat = 8
    private var sheetTopRadius: CGFloat = 40
    private var expandedY: CGFloat { safeAreaInsets.top + Theme.spacing.md }
    private var collapsedY: CGFloat { screenSize.height - collapsedHeight - sheetSpace }
    private var hiddenY: CGFloat { screenSize.height + Theme.spacing.xxxl }
    
    private var baseOffsetY: CGFloat {
        switch manager.state {
        case .hidden: return hiddenY
        case .collapsed: return collapsedY
        case .expanded: return expandedY
        }
    }
    
    private var currentY: CGFloat { baseOffsetY + dragOffset }
    
    private var progress: CGFloat {
        let totalDist = collapsedY - expandedY
        if totalDist == 0 { return 0 }
        let p = (collapsedY - currentY) / totalDist
        return min(max(p, 0.0), 1.0)
    }
    
    init(
        manager: BottomSheetManager,
        screenSize: CGSize,
        safeAreaInsets: EdgeInsets,
        @ViewBuilder content: () -> Content
    ) {
        self.manager = manager
        self.screenSize = screenSize
        self.safeAreaInsets = safeAreaInsets
        self.content = content()
    }
    
    var body: some View {
        let currentWidth = (screenSize.width - (sheetSpace * 2)) + ((sheetSpace * 2) * progress)
        let expandedHeight = screenSize.height - expandedY
        let currentHeight = collapsedHeight + ((expandedHeight - collapsedHeight) * progress)
        let currentRadius: CGFloat = progress >= 0.999 ? 0 : safeAreaInsets.top - 4
        
        VStack(spacing: 0) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: currentWidth, height: currentHeight, alignment: .top)
        .background(
            Theme.colors.sectionForeground
        )
        .scrollIndicators(.hidden)
        .clipShape(
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: sheetTopRadius,
                    bottomLeading: currentRadius,
                    bottomTrailing: currentRadius,
                    topTrailing: sheetTopRadius
                )
            )
        )
        .offset(y: currentY)
        .scrollDisabled(manager.state == .collapsed || isDraggingSheet)
        .gesture(panGesture)
    }
    
    private var panGesture: some UIGestureRecognizerRepresentable {
            CustomPanGesture(
                onChanged: { recognizer in
                    let y = recognizer.translation(in: nil).y
                    
                    if manager.state == .expanded {
                        if y < 0 {
                            isDraggingSheet = false
                            dragOffset = 0
                        } else if y > 0 {
                            if manager.scrollOffset <= 0 {
                                if !isDraggingSheet {
                                    isDraggingSheet = true
                                    dragStartTranslation = y
                                }
                                dragOffset = y - dragStartTranslation
                            } else {
                                isDraggingSheet = false
                            }
                        }
                    } else if manager.state == .collapsed {
                        isDraggingSheet = true
                        if y > 0 {
                            dragOffset = y * 0.3
                        } else {
                            dragOffset = y
                        }
                    }
                },
                onEnded: { recognizer in
                    let y = recognizer.translation(in: nil).y
                    let velocity = recognizer.velocity(in: nil).y
                    
                    if manager.state == .collapsed {
                        withAnimation(.normalSpring) {
                            if y < -50 || velocity < -300 {
                                manager.state = .expanded
                            } else if y > 50 || velocity > 300 {
                                manager.dismiss()
                            }
                            dragOffset = 0
                        }
                    } else if manager.state == .expanded {
                        if isDraggingSheet {
                            let actualDrag = y - dragStartTranslation
                            withAnimation(.normalSpring) {
                                if actualDrag > 100 || velocity > 300 {
                                    manager.state = .collapsed
                                }
                                dragOffset = 0
                            }
                        }
                    }
                    
                    isDraggingSheet = false
                    dragStartTranslation = 0
                }
            )
        }
}
