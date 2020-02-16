//
//  VideoContainerView.swift
//  LambdaTimeline
//
//  Created by Chad Rutherford on 2/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class VideoContainerView: UIView {
    var playerLayer: CALayer?
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
    }
}
