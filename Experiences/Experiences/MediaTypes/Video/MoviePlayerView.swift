//
//  MoviePlayerView.swift
//  Experiences
//
//  Created by Sal B Amer on 5/15/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
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

