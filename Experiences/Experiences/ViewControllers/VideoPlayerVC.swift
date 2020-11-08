//
//  VideoPlayerVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import AVKit

class VideoPlayerVC: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private var videoPlayer: VideoPlayerView!
    
    // MARK: - Properties
    
    var videoURL: URL?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.player = AVPlayer()
    }
    
    // MARK: - Actions

    @IBAction func playButton(_ sender: UIButton) {
        guard let videoURL = videoURL else { return }
        videoPlayer.player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
        videoPlayer.player?.play()
    }
    
}
