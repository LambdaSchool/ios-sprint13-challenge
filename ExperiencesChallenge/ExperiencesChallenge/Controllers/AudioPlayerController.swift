//
//  AudioPlayerController.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//


import Foundation
import AVFoundation

class AudioPlayerController: NSObject {

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

