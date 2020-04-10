//
//  Player.swift
//  Experiences
//
//  Created by Keri Levesque on 4/10/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import AVFoundation

protocol PlayerDelegate {
    func playDidChangeState(player: Player)
}

class Player: NSObject {
    
    // MARK: Properties
    
    var delegate: PlayerDelegate?
    var audioPlayer: AVAudioPlayer?
    var url: URL
    
    var timer: Timer?
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    var timeElspsed: TimeInterval {
        return audioPlayer?.currentTime ?? 0.0
    }
   
    var duration: TimeInterval {
        return audioPlayer?.duration ?? 0.0
    }
    var timeRemaining: TimeInterval {
        return duration - timeElspsed
    }
    
    //MARK: Initializer
    
    init(url: URL) { //= Bundle.main.url(forResource: "piano", withExtension: "mp3")!) {
        self.url = url
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: self.url)
        } catch {
            NSLog("Error opening \(url)): \(error)")
        }
        super.init()
        audioPlayer?.delegate = self
    }
    
    
    //play
    func play() {
        audioPlayer?.play()
        delegate?.playDidChangeState(player: self)
        startTimer()
    }
    
    //pause
    func pause () {
        audioPlayer?.pause()
        delegate?.playDidChangeState(player: self)
        cancelTimer()
    }
    
    //playPause
    func playPause () {
        if isPlaying {
            self.pause()
        } else {
            self.play()
        }
    }
    
    func startTimer() {
        cancelTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer(timer: Timer) {
        delegate?.playDidChangeState(player: self)
    }
    
    
    //seekToPosition: Double
    
}

extension Player: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        NSLog("AVAudio Error: \(String(describing: error))")
        cancelTimer()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.playDidChangeState(player: self)
        cancelTimer()
    }
}
