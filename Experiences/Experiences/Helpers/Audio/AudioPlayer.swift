//
//  AudioPlayer.swift
//  LambdaTimeline
//
//  Created by Marlon Raskin on 10/1/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation

protocol AudioPlayerDelegate {
    func playerDidChangeState(_ player: AudioPlayer)
}

class AudioPlayer: NSObject {

    // MARK: - Computed & Non-computed properties

    var audioPlayer: AVAudioPlayer?
    var delegate: AudioPlayerDelegate?
    var timer: Timer?

    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }

    var currentTime: TimeInterval {
        audioPlayer?.currentTime ?? 0
    }

    var timeRemaining: TimeInterval {
        duration - currentTime
    }

    var duration: TimeInterval {
        audioPlayer?.duration ?? 0
    }

    // MARK: - Init()

    override init() {
        super.init()
    }

    // MARK: - Player Functions

    func loadAudio(with url: URL) throws {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
    }

    func play() {
        audioPlayer?.play()
        
        startTimer()
        notifyDelegate()
    }

    func pause() {
        audioPlayer?.pause()
        stopTimer()
        notifyDelegate()
    }

    func playPause() {
        isPlaying ? pause() : play()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            self.notifyDelegate()
        })
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Notification

    private func notifyDelegate() {
        delegate?.playerDidChangeState(self)
    }
}
