//
//  AudioManager.swift
//  LambdaTimeline
//
//  Created by Chad Rutherford on 2/11/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import AVFoundation
import Foundation

protocol AudioManagerDelegate: class {
    func isRecording()
    func doneRecording(with url: URL)
    func didPlay()
    func didPause()
    func didFinishPlaying()
    func didUpdate()
}

class AudioManager: NSObject {
    
    // MARK: - Properties
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var timer: Timer?
    weak var delegate: AudioManagerDelegate?
    var recordingURL: URL?
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    // MARK: - API Methods
    func toggleRecordingMode() {
        if isRecording {
            stopRecording()
        } else {
            requestRecordPermission()
        }
    }
    
    func loadAudio(with url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(data: Data(contentsOf: url))
            audioPlayer?.delegate = self
        } catch {
            NSLog("Audio playback error: \(error.localizedDescription)")
        }
    }
    
    func togglePlayMode() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    // MARK: - Private
    private func startRecording() {
        guard let recordingURL = makeNewRecordingURL() else { return }
        guard let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1) else { return }
        do {
            self.recordingURL = recordingURL
            audioRecorder = try AVAudioRecorder(url: recordingURL, format: format)
            audioRecorder?.record()
            delegate?.isRecording()
        } catch {
            NSLog("Audio recording error: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        guard let url = recordingURL else { return }
        delegate?.doneRecording(with: url)
    }
    
    private func play() {
        audioPlayer?.play()
        delegate?.didPlay()
        startTimer()
    }
    
    private func pause() {
        audioPlayer?.pause()
        delegate?.didPause()
        cancelTimer()
    }
    
    private func startTimer() {
        cancelTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
    }
    
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer(_ timer: Timer) {
        delegate?.didUpdate()
    }
    
    private func requestRecordPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                guard granted else {
                    fatalError("We need microphone access")
                }
                self.startRecording()
            }
        }
    }
    
    private func makeNewRecordingURL() -> URL? {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let url = documents.appendingPathComponent(name).appendingPathExtension("caf")
        return url
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.didFinishPlaying()
        cancelTimer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            NSLog("Audio playback error: \(error.localizedDescription)")
        }
    }
}
