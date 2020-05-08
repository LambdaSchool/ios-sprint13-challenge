//
//  AudioDeck.swift
//  AudioComments
//
//  Created by Shawn Gee on 5/6/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioDeckDelegate: AnyObject {
    func didRecord(to fileURL: URL, with duration: TimeInterval)
    func didUpdatePlaybackLocation(to time: TimeInterval)
    func didFinishPlaying()
    func didUpdateAudioAmplitude(to decibels: Float)
}

extension AudioDeckDelegate {
    func didRecord(to fileURL: URL, with duration: TimeInterval) {}
    func didUpdatePlaybackLocation(to time: TimeInterval) {}
    func didFinishPlaying() {}
    func didUpdateAudioAmplitude(to decibels: Float) {}
}

class AudioDeck: NSObject {
    
    // MARK: - Public Properties
    
    var isRecording: Bool { recorder?.isRecording ?? false }
    var isPlaying: Bool { player?.isPlaying ?? false }
    var fileURL: URL? { player?.url }
    var fileDuration: TimeInterval? { player?.duration }
    
    weak var delegate: AudioDeckDelegate?
    
    // MARK: - Private Properties
    
    private var recorder: AVAudioRecorder?
    private var recordingURL: URL?
    private var player: AVAudioPlayer?
    
    private var updateTimer: Timer?
    
    // MARK: - Init
    
    convenience init(delegate: AudioDeckDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    
    func open(audioFile url: URL) {
        try? setPlayer(url: url)
    }
    
    func startRecording() {
        let recordingURL = createNewRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        recorder = try? AVAudioRecorder(url: recordingURL, format: format)
        recorder?.isMeteringEnabled = true
        recorder?.delegate = self
        
        recorder?.record()
        self.recordingURL = recordingURL
        startUpdateTimer()
    }
    
    func stopRecording() {
        recorder?.stop()
        stopUpdateTimer()
    }
    
    func play() {
        player?.play()
        startUpdateTimer()
    }
    
    func pause() {
        player?.pause()
        stopUpdateTimer()
    }
    
    func scrub(to time: TimeInterval) {
        guard let player = player else { return }
        player.currentTime = time
    }
    
    // MARK: - Private Methods
    
    private func setPlayer(url: URL) throws {
        player = try AVAudioPlayer(contentsOf: url)
        player!.isMeteringEnabled = true
        player!.delegate = self
    }
    
    private func createNewRecordingURL() -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let fileURL = tempDir.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(fileURL)")
        
        return fileURL
    }
    
    private func startUpdateTimer() {
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    private func stopUpdateTimer() {
        updateTimer?.invalidate()
    }
    
    @objc func update() {
        if isPlaying {
            guard let player = player else { return }
            player.updateMeters()
            delegate?.didUpdateAudioAmplitude(to: player.averagePower(forChannel: 0))
            delegate?.didUpdatePlaybackLocation(to: player.currentTime)
        } else if isRecording {
            guard let recorder = recorder else { return }
            recorder.updateMeters()
            delegate?.didUpdateAudioAmplitude(to: recorder.averagePower(forChannel: 0))
        }
    }
    

}

// MARK: - AVAudioRecorderDelegate

extension AudioDeck: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag, let recordingURL = recordingURL  {
            do {
                try setPlayer(url: recordingURL)
                delegate?.didRecord(to: recordingURL, with: player!.duration)
            } catch {
                print(error)
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("⚠️ Audio Recorder Error: \(error)")
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioDeck: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        update()
        delegate?.didFinishPlaying()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("⚠️ Audio Player Error: \(error)")
        }
    }
}
