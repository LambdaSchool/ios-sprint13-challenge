//
//  VideoTableViewCell.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import AVFoundation

class VideoTableViewCell: UITableViewCell {

    var url: URL? { didSet { setUpVideo() }}

    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    
    func setUpVideo() {
        guard let url = url else { return }
        videoPlayerView.player = AVPlayer(url: url)
    }
}
