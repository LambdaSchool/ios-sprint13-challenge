//
//  Player.swift
//  Experiences
//
//  Created by Ciara Beitel on 11/4/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import AVFoundation

 protocol PlayerDelegate {
    func playerDidChangeState(player: Player)

 }

 class Player: NSObject {
    
    var audioPlayer: AVAudioPlayer?
    var delegate: PlayerDelegate?
    var url: URL?
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    init(url: URL?) {
        self.url = url
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
        delegate?.playerDidChangeState(player: self)
     }
}
