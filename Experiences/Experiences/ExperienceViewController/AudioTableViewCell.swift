//
//  AudioTableViewCell.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class AudioTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    var url: URL? { didSet { setUpAudioDeck() }}
    
    // MARK: - Private Properties
    
    private var audioPlayer: AudioDeck?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timelineSlider: UISlider!
        
    // MARK: - Private Methods
    
    private func setUpAudioDeck() {
        guard let url = url else { return }
        audioPlayer = AudioDeck(delegate: self)
        audioPlayer?.open(audioFile: url)
        if let maxTime = audioPlayer?.fileDuration {
            timelineSlider.maximumValue = Float(maxTime)
        }
    }
        
    private func play() {
        audioPlayer?.play()
        playPauseButton.isSelected = true
    }
    
    private func pause() {
        audioPlayer?.pause()
        playPauseButton.isSelected = false
    }
    
    @IBAction func togglePlayback(_ sender: Any) {
        if let player = audioPlayer, player.isPlaying {
            pause()
        } else {
            play()
        }
    }
    @IBAction func scrubTimeline(_ sender: UISlider) {
        audioPlayer?.scrub(to: TimeInterval(sender.value))
    }
}

extension AudioTableViewCell: AudioDeckDelegate {
    func didUpdatePlaybackLocation(to time: TimeInterval) {
        timelineSlider.value = Float(time)
    }
    
    func didFinishPlaying() {
        playPauseButton.isSelected = false
        timelineSlider.value = 0
    }
}
