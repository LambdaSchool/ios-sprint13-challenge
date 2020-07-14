//
//  CameraPreviewView.swift
//  Experiences-sprint-chanllenge
//
//  Created by Gi Pyo Kim on 12/6/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
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
