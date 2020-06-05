//
//  VideoView.swift
//  Experiences
//
//  Created by brian vilchez on 2/15/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import UIKit
import AVFoundation

class VideoView: UIView {

    func playVideo() {
        let url = Bundle.main.url(forResource: "", withExtension: nil)
           guard let videoURL = url else { return }
            let videoPlayer = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: videoPlayer)
            playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        videoPlayer.play()
    }

}

/*
        let url = NSURL(string: "YOUR URL")
          let player = AVPlayer(URL: videoURL!)
          let playerLayer = AVPlayerLayer(player: player)
          playerLayer.frame = self.view.bounds
          self.view.layer.addSublayer(playerLayer)
          player.play()
 */
