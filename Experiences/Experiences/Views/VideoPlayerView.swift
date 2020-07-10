//
//  VideoPlayerView.swift
//  Experiences
//
//  Created by Enzo Jimenez-Soto on 7/10/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import UIKit
import AVFoundation

    class VideoPlayerView: UIView {
        override class var layerClass: AnyClass {
            return AVPlayerLayer.self
        }
        var videoPlayerLayer: AVPlayerLayer {
            return layer as! AVPlayerLayer
        }
        var player: AVPlayer? {
            get { return videoPlayerLayer.player }
            set { videoPlayerLayer.player = newValue }
        }
}
