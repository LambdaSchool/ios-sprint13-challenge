//
//  VideoPlayerHelper.swift
//  Experiences
//
//  Created by Bronson Mullens on 9/11/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerHelper: UIView {
    
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
