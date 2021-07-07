//
//  AudioPlayer.swift
//  ExperienceLog
//
//  Created by Bradley Yin on 10/4/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import AVFoundation

protocol AudioPlayerDelegate {
    func playerStateDidChange()
}

class AudioPlayer: NSObject {
    var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    var delegate: AudioPlayerDelegate?
    
    override init() {
        //self.audioPlayer = AVAudioPlayer()
        super.init()
    }
    
    func load(data: Data)throws {
        //audioPlayer = nil
        audioPlayer = try AVAudioPlayer(data: data)
        audioPlayer?.delegate = self
    }
    func load(url: URL)throws {
        //audioPlayer = nil
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.delegate = self
    }
    
    private func play() {
        audioPlayer?.play()
        notifyDelegate()
    }
    
    private func pause() {
        audioPlayer?.pause()
        notifyDelegate()
    }
    
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    func notifyDelegate() {
        delegate?.playerStateDidChange()
    }
}
extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Error playing audio file: \(error)")
        }
        
        // TODO: should we propogate this error back, new method in delegate protocol
        notifyDelegate()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // TODO: should we add a delegate protocol method?
        notifyDelegate()
    }
}
