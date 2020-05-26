//
//  MoviePlayerView.swift
//  Experiences
//
//  Created by Gerardo Hernandez on 5/26/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import AVFoundation

class MoviePlayerView: UIView {
    
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
