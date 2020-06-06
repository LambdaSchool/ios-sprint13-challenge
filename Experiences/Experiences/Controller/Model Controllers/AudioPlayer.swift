//
//  AudioPlayer.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import AVFoundation
import UIKit

class AudioPlayer {
    var delegate: AudioPlayerUIDelegate?
    private var timer: Timer?
    ///the active Audio Player
    var player: AVAudioPlayer? {
        didSet {
            player?.delegate = delegate
        }
    }

    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }

    init(delegate: AudioPlayerUIDelegate) {
        self.delegate = delegate
        loadAudio()
    }

    deinit {
        cancelTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            self.delegate?.updatePlayerUI()
        }
    }

    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
        delegate?.updatePlayerUI()
    }

    private func loadAudio() {
        guard let songURL = delegate?.recordedURL else { return }
        do {
            player = try AVAudioPlayer(contentsOf: songURL)
        } catch let audioError {
            print("Error loading audio file: \(audioError)")
        }

    }

    func togglePlaying() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    private func play() {
        player?.play()
        startTimer()
    }

    private func pause() {
        player?.pause()
        cancelTimer()
    }
}

