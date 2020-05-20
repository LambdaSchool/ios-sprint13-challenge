//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Joe on 5/20/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPlayerLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get { return videoPlayerLayer.session
            set { videoPlayerLayer.session = newValue }
        }
    }

}
