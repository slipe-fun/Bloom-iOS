//
//  FPSCounter.swift
//  Bloom
//
//  Created by Аскольд on 08.08.2026.
//

import SwiftUI
import QuartzCore

#if DEBUG
class FPSCounter: ObservableObject {
    @Published var fps: Int = 0
    
    private var displayLink: CADisplayLink?
    private var lastUpdate: CFTimeInterval = 0
    private var frameCount: Int = 0
    
    func start() {
        guard displayLink == nil else { return }
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
    
        let range = CAFrameRateRange(minimum: 60, maximum: 120, preferred: 120)
        displayLink?.preferredFrameRateRange = range
        
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stop() {
        displayLink?.invalidate()
        displayLink = nil
        lastUpdate = 0
        frameCount = 0
    }
    
    @objc private func update(link: CADisplayLink) {
        if lastUpdate == 0 {
            lastUpdate = link.timestamp
            return
        }
        
        frameCount += 1
        let delta = link.timestamp - lastUpdate
        
        if delta >= 0.5 {
            fps = Int((Double(frameCount) / delta).rounded())
            frameCount = 0
            lastUpdate = link.timestamp
        }
    }
}

struct FPSOverlayView: View {
    @StateObject private var counter = FPSCounter()
    
    var body: some View {
        Text("\(counter.fps) FPS")
            .font(.system(size: 12, weight: .bold, design: .monospaced))
            .foregroundColor(fpsColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.black.opacity(0.6))
            .clipShape(Capsule())
            .onAppear { counter.start() }
            .onDisappear { counter.stop() }
            .allowsHitTesting(false)
    }
    
    private var fpsColor: Color {
        if counter.fps >= 110 { return .green }
        if counter.fps >= 55 { return .yellow }
        return .red
    }
}
#endif

extension View {
    @ViewBuilder
    func showFPS() -> some View {
        #if DEBUG
        self.overlay(
            FPSOverlayView()
                .padding(.top, 50)
                .padding(.trailing, 16),
            alignment: .topTrailing
        )
        #else
        self
        #endif
    }
}
