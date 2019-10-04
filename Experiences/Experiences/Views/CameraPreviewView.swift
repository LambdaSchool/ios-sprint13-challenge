//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
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
//            videoPlayerView.videoGravity = .resizeAspectFill
        }
    }
}
