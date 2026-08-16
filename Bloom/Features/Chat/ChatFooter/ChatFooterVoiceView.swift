//
//  ChatFooterVoiceView.swift
//  Bloom
//
//  Created by Аскольд on 16.08.2026.
//

import SwiftUI

struct ChatFooterVoiceView: View {
    let isRecordingLocked: Bool

    @StateObject private var recorder = AudioRecorderManager()

    var body: some View {
        ChatFooterWaveformView(samples: recorder.samples)
            .frame(height: 64, alignment: .center)
            .padding(.trailing, Theme.spacing.md)
            .onChange(of: isRecordingLocked) { _, locked in
                if locked {
                    recorder.startRecording()
                }
            }

        elapsedTimeView
            .frame(maxHeight: .infinity, alignment: .center)

        Button {
            recorder.stopRecording()
        } label: {
            Image(systemName: "square.fill")
                .font(.subheadline)
                .foregroundStyle(Theme.colors.red)
        }
        .buttonStyle(.plain)
        .frame(width: 36, height: 36)
        .background(Theme.colors.red.opacity(0.35), in: Circle())
        .padding(.leading, Theme.spacing.md)
        .padding(.vertical, Theme.spacing.md + 2)
        .padding(.trailing, Theme.spacing.md + 2)
    }

    @ViewBuilder
    private var elapsedTimeView: some View {
        if let startDate = recorder.recordingStartDate {
            TimelineView(.periodic(from: startDate, by: 1)) { context in
                let elapsed = max(0, Int(context.date.timeIntervalSince(startDate)))
                timeText(elapsed)
            }
        } else {
            timeText(Int(recorder.lastRecordedDuration))
        }
    }

    private func timeText(_ elapsedSeconds: Int) -> some View {
        Text(formattedTime(elapsedSeconds))
            .font(.system(.subheadline, design: .rounded, weight: .medium))
            .monospacedDigit()
            .contentTransition(.numericText(value: Double(elapsedSeconds)))
            .animation(.snappy(duration: 0.235), value: elapsedSeconds)
    }

    private func formattedTime(_ elapsedSeconds: Int) -> String {
        String(format: "%02d:%02d", elapsedSeconds / 60, elapsedSeconds % 60)
    }
}
