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
    }
    
    func pause() {
        audioPlayer?.pause()
        delegate?.playerDidChangeState(player: self)
    }
    
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
}
extension Player: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("AVAudioError: \(String(describing: error))")
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // send delegate message to update the UI
        delegate?.playerDidChangeState(player: self)
        
    }
}
