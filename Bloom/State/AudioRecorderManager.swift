//
//  AudioRecorderManager.swift
//  Bloom
//
//  Created by Аскольд on 16.08.2026.
//

import Foundation
import AVFoundation
import Combine
import SwiftUI

struct AudioSample: Identifiable, Equatable {
    let id = UUID()
    let value: CGFloat
}

final class AudioRecorderManager: ObservableObject {
    @Published private(set) var samples: [AudioSample] = []
    @Published private(set) var isRecording = false
    @Published private(set) var permissionDenied = false
    @Published private(set) var recordingStartDate: Date?
    @Published private(set) var lastRecordedDuration: TimeInterval = 0

    private var audioRecorder: AVAudioRecorder?
    private var timer: DispatchSourceTimer?
    private let audioQueue = DispatchQueue(label: "com.bloom.audioRecorderQueue", qos: .userInitiated)

    private let sampleInterval: Double = 0.1
    private let maxMemorySamples = 55
    private var lastSample: CGFloat = 0.0

    func startRecording() {
        guard !isRecording else { return }

        requestRecordPermission { [weak self] granted in
            guard let self else { return }
            guard granted else {
                self.permissionDenied = true
                return
            }
            self.permissionDenied = false
            self.beginRecording()
        }
    }

    func stopRecording() {
        guard isRecording else { return }

        isRecording = false
        if let start = recordingStartDate {
            lastRecordedDuration = Date().timeIntervalSince(start)
        }
        recordingStartDate = nil

        audioQueue.async { [weak self] in
            guard let self else { return }
            self.stopTimerOnQueue()
            self.audioRecorder?.stop()
            self.audioRecorder = nil
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        }
    }

    // MARK: - Permission

    private func requestRecordPermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            DispatchQueue.main.async { completion(true) }
        case .denied:
            DispatchQueue.main.async { completion(false) }
        case .undetermined:
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        @unknown default:
            DispatchQueue.main.async { completion(false) }
        }
    }

    // MARK: - Recording lifecycle

    private func beginRecording() {
        samples.removeAll()
        lastSample = 0.0

        audioQueue.async { [weak self] in
            guard let self else { return }

            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
                try audioSession.setActive(true)

                let tempDir = FileManager.default.temporaryDirectory
                let fileURL = tempDir.appendingPathComponent("temp_voice_recording.m4a")

                let settings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100.0,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
                ]

                let recorder = try AVAudioRecorder(url: fileURL, settings: settings)
                recorder.isMeteringEnabled = true
                recorder.record()

                self.audioRecorder = recorder
                self.startTimerOnQueue()

                let startDate = Date()
                DispatchQueue.main.async {
                    self.recordingStartDate = startDate
                    self.isRecording = true
                }
            } catch {
                print("AudioRecorder Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isRecording = false
                }
            }
        }
    }

    private func startTimerOnQueue() {
        stopTimerOnQueue()
        let timer = DispatchSource.makeTimerSource(queue: audioQueue)
        timer.schedule(deadline: .now(), repeating: sampleInterval)
        timer.setEventHandler { [weak self] in
            self?.fetchAudioLevel()
        }
        timer.resume()
        self.timer = timer
    }

    private func stopTimerOnQueue() {
        timer?.cancel()
        timer = nil
    }

    private func fetchAudioLevel() {
        guard let recorder = audioRecorder, recorder.isRecording else { return }
        recorder.updateMeters()

        let power = recorder.averagePower(forChannel: 0)
        let minDb: Float = -50.0

        let normalized = min(max((power - minDb) / (-minDb), 0.0), 1.0)
        let rawTarget = pow(CGFloat(normalized), 1.25)
        let smoothed = lastSample * 0.1 + rawTarget * 0.9
        lastSample = smoothed

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            withAnimation(.smooth(duration: 0.25)) {
                self.samples.append(AudioSample(value: smoothed))
                if self.samples.count > self.maxMemorySamples {
                    self.samples.removeFirst(self.samples.count - self.maxMemorySamples)
                }
            }
        }
    }

    deinit {
        timer?.cancel()
        audioRecorder?.stop()
    }
}
