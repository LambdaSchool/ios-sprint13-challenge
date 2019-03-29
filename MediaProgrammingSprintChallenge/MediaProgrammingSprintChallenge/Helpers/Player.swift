//
//  Player.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import AVFoundation

protocol PlayerDelegate: AnyObject {
    func playerDidChangeState(player: Player)
}

class Player: NSObject {
    
    override init() {
        super.init()
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.delegate = self
    }
    
    func play() {
        audioPlayer.play()
        notifyDelegate()
    }
    
    func pause() {
        audioPlayer.pause()
        notifyDelegate()
    }
    
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    private func notifyDelegate() {
        delegate?.playerDidChangeState(player: self)
    }
    
    var isPlaying: Bool {
        return audioPlayer.isPlaying
    }
    
    weak var delegate: PlayerDelegate?
    var url = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
    private var audioPlayer: AVAudioPlayer!
}

extension Player: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("audioPlayerDecodeErrorDidOccur: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        notifyDelegate()
    }
}
