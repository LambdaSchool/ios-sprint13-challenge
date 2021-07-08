//
//  Player.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerDelegate: AnyObject {
    func playerDidChangeState(_ player: Player)
}

class Player: NSObject, AVAudioPlayerDelegate {
    // in order to be the delegate of our audioPlayer
    
    
    init(_ completion : (() -> Void)? = nil) {
        super.init()
        
    }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    var elapsedTime: TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }
    
    var songDuration: TimeInterval {
        return audioPlayer?.duration ?? 0
    }
    
    var remainingTime: TimeInterval {
        return songDuration - elapsedTime
    }
    
    
    func playPause(song: URL? = nil) {
        if isPlaying {
            pause()
        } else {
            play(song: song)
        }
    }
    
    func play(song: URL? = nil){
        let file = song ?? Bundle.main.url(forResource:"Brazil", withExtension: "caf")!
        
        if audioPlayer == nil || audioPlayer?.url != file {
            // make an audioPlayer
            audioPlayer = try! AVAudioPlayer(contentsOf: file)
            audioPlayer?.delegate = self
        }
        audioPlayer?.play()
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.notifyDelegate()
        }
        
        notifyDelegate()
    }
    
    func pause(){
        audioPlayer?.pause()
        notifyDelegate()
    }
    
    func stop(){
        audioPlayer?.stop()
        notifyDelegate()
    }
    
    // MARK: - Private Methods
    private func notifyDelegate(){
        delegate?.playerDidChangeState(self)
    }
    
    // MARK: - AVAudioPlayerDelegate Methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        notifyDelegate()
    }
    
    // MARK: - Propeties
    weak var delegate: PlayerDelegate?
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
}
