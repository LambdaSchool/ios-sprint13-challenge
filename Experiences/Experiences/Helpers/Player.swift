//
//  Player.swift
//  LambdaTimeline
//
//  Created by Jake Connerly on 10/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation

protocol PlayerDelegate {
    func playerDidChangeState(player: Player)
    
}

class Player: NSObject {
    
    var audioPlayer: AVAudioPlayer?
    var delegate: PlayerDelegate?
    var url: URL?
    var timer: Timer?
    
    var timeElapsed: TimeInterval {
        audioPlayer?.currentTime ?? 0.0
    }
    
    var duration: TimeInterval {
        audioPlayer?.duration ?? 0.0
    }
    
    var timeRemaining: TimeInterval {
        duration - timeElapsed
    }
    
    init(url: URL?) {
        self.url = url
        
        // create an audio player
        do {
            if let url = url {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
            }
        } catch {
            print("AudioPlayer Error: \(url)")
        }
        
        super.init()
        audioPlayer?.delegate = self
    }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    func play() {
        audioPlayer?.play()
        delegate?.playerDidChangeState(player: self)
        startTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        delegate?.playerDidChangeState(player: self)
        cancelTimer()
    }
    
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
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
        delegate?.playerDidChangeState(player: self)
    }
    
    
}
extension Player: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("AVAudioError: \(String(describing: error))")
        cancelTimer()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // send delegate message to update the UI
        delegate?.playerDidChangeState(player: self)
        cancelTimer()
    }
}
