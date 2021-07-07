//
//  PostDetailViewController.swift
//  ExperienceLog
//
//  Created by Bradley Yin on 10/4/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var playVideoButton: UIButton!
    
    var post: Post!
    let audioPlayer = AudioPlayer()
    var videoPlayer: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        
        if let audio = post.audioURL {
            playAudioButton.isHidden = false
            do {
                try audioPlayer.load(url: audio)
                audioPlayer.delegate = self
            } catch {
                print("cant init audio player")
            }
        } else {
            playAudioButton.isHidden = true
        }
        if let video = post.videoURL {
            playVideoButton.isHidden = false
            videoPlayer = AVPlayer(url: video)
        } else {
            playVideoButton.isHidden = true
        }

        // Do any additional setup after loading the view.
    }
    
    private func setupViews() {
        titleTextField.text = post.title
        imageView.image = post.image
        noteTextView.text = post.note
        
    }
    @IBAction func playAudioButtonTapped(_ sender: Any) {
        print("play audio")
        audioPlayer.playPause()
    }
    @IBAction func playVideoButtonTapped(_ sender: Any) {
        print("play video")
        let avplayerVC = AVPlayerViewController()
        avplayerVC.player = videoPlayer
        present(avplayerVC, animated: true)
    }
    
}
extension PostDetailViewController: AudioPlayerDelegate {
    func playerStateDidChange() {
        let buttonName = audioPlayer.isPlaying ? "Pause" : "Play Audio"
        playAudioButton.setTitle(buttonName, for: .normal)
    }
}
