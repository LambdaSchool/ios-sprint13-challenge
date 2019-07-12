//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Mitchell Budge on 7/12/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPlayerView: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get { return videoPlayerView.session}
        set { videoPlayerView.session = newValue }
    }
}
