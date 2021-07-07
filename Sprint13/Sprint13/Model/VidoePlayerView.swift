//
//  VidoePlayerView.swift
//  Sprint13
//
//  Created by Sergey Osipyan on 2/24/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation
import UIKit
import AVKit;
import AVFoundation;

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
