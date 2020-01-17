//
//  AudioPlayerController.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
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
            audioPlayer?.delegate = self
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

extension AudioPlayerController: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player error: \(error)")
        }
    }
}
