//
//  AudioPlayerController.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
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
            print("Error loading audio")
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
    
    private func startTimer() {
        cancelTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
    }
    
    func pausePlay() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    
    
    @objc private func updateTimer(timer: Timer) {
        
    }
    
    
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}
