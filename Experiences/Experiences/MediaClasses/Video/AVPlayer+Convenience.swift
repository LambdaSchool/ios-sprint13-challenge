//
//  AVPlayer+Convenience.swift
//  VideoPost
//
//  Created by Shawn Gee on 5/7/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return self.rate > 0
    }
    
    var assetURL: URL? {
        return (self.currentItem?.asset as? AVURLAsset)?.url
    }
}
