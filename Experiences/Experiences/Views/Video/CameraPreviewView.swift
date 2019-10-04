//
//  CameraPreviewView.swift
//  LambdaTimeline
//
//  Created by Marlon Raskin on 10/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var videoPlayerView: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }

    var session: AVCaptureSession? {
        get { return videoPlayerView.session }
        set {
            videoPlayerView.session = newValue
            videoPlayerView.videoGravity = .resizeAspectFill
        }
    }
}
