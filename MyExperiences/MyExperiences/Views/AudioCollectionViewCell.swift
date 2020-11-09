//
//  AudioCollectionViewCell.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit
import AVFoundation

protocol cellIndexPathDelegate2: AnyObject {
    func locationButtonTapped(cell: AudioCollectionViewCell)
}

class AudioCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?
        var delegate: cellIndexPathDelegate2?
        var post: PostExperiences?{
            didSet{
                updateViews()
            }
        }

        override func layoutSubviews() {
             super.layoutSubviews()
         }

        private func updateViews() {
            playButton.backgroundColor = .systemOrange
            playButton.layer.cornerRadius = 25
        }

        func prepareAudioSession() throws {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, options: [.defaultToSpeaker])
            try session.setActive(true, options: [])
        }

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
