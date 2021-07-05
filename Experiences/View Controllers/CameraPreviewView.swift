//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Dennis Rudolph on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

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
