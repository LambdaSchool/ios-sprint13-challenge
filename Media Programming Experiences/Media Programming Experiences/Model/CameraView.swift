//
//  CameraView.swift
//  Media Programming Experiences
//
//  Created by Ivan Caldwell on 2/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    
    override class var layerClass: AnyClass{
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        } set {
            // newValue is built in
            videoPreviewLayer.session = newValue
        }
    }
}
