//
//  CameraPreview.swift
//  Experiences
//
//  Created by Keri Levesque on 4/10/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
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
        get { return videoPlayerView.session }
        set { videoPlayerView.session = newValue }
    }
}
