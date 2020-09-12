//
//  AudioCollectionViewCell.swift
//  experiences
//
//  Created by Clayton Watkins on 9/11/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit
import AVFoundation

// This delegate will allow us to get the indexPath of the cell when tapping on a button
protocol cellIndexPathDelegate2: AnyObject {
    func locationButtonTapped(cell: AudioCollectionViewCell)
}

class AudioCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // MARK: - Properties
    var audioPlayer: AVAudioPlayer?
    var delegate: cellIndexPathDelegate2?
    var post: Post?{
        didSet{
            updateViews()
        }
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
     }
    
    // MARK: - Private
    private func updateViews() {
        playButton.backgroundColor = .systemOrange
        playButton.layer.cornerRadius = 25
    }
    
   private func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    // MARK: - IBActions
    @IBAction func playButtonTapped(_ sender: Any) {
        do {
            try prepareAudioSession()
            if let recordingURL = post?.audioURL{
                print(recordingURL)
                audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
                guard let audioPlayer = self.audioPlayer else { return }
                audioPlayer.play()
            }
            
        } catch {
            preconditionFailure("Failure to load audio file at path \(post!.audioURL!): \(error)")
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        delegate?.locationButtonTapped(cell: self)
    }
}
