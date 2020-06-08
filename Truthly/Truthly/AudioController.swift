//
//  AudioController.swift
//  Truthly
//
//  Created by Ezra Black on 6/8/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController: NSObject {

    var audioPlayer: AVAudioPlayer?
    var timer: Timer?

    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }

    func loadAudio(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Error loading in audio")
        }
    }

    private func play() {
        audioPlayer?.play()
        startTimer()
    }

    private func pause() {
        audioPlayer?.pause()
        cancelTimer()
    }

    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    private func startTimer() {
        cancelTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.03,
                                     target: self,
                                     selector: #selector(updateTimer(timer:)),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc private func updateTimer(timer: Timer) {

    }

    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}
