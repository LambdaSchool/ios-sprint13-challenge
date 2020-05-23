//
//  AudioManager.swift
//  Experiences
//
//  Created by Joe on 5/23/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioManagerDelegate: class {
    func isRecording()
    func doneRecording(with url: URL)
    func didPlay()
    func didPause()
    func didFinishPlaying()
    func didUpdate()
}

class AudioManager: NSObject {
    //MARK: - Properties
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var session: AVAudioSession?
    var timer: Timer?
    weak var delegate: AudioManagerDelegate?
    var recordingURL: URL?
    var title: String!
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    override init() {
        session = AVAudioSession.sharedInstance()
        do {
            try session?.setCategory(.playAndRecord, mode: .default)
            try session?.overrideOutputAudioPort(.speaker)
            try session?.setActive(true)
        } catch {
            print("There was an error with the session \(error)")
        }
        super.init()
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
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
        } catch {
            print("There was an error with the audio Playback: \(error)")
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
        let recordingURL = URL.makeNewAudioURL(with: title)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            self.recordingURL = recordingURL
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            delegate?.isRecording()
        } catch {
            stopRecording()
        }
    }
    private func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        cancelTimer()
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
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
    }
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer(_ timer: Timer) {
        delegate?.didUpdate()
    }
    private func requestRecordPermission() {
        session?.requestRecordPermission { granted in
            DispatchQueue.main.async {
                guard granted else {
                    print("Failed to record")
                    return
                }
                self.startRecording()
            }
        }
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.didFinishPlaying()
        cancelTimer()
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("There was an error with audio playback: \(error)")
        }
    }
}
extension AudioManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard let fileURL = recordingURL else { return }
        delegate?.doneRecording(with: fileURL)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio recording error: \(error)")
        }
    }
    
}
