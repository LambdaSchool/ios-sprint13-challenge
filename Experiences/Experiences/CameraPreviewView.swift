//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Julian A. Fordyce on 3/29/19.
//  Copyright © 2019 Julian A. Fordyce. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class CameraPreviewView: UIView {
    
    override class var layerClass : AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get { return videoPreviewLayer.session }
        set { videoPreviewLayer.session = newValue }
    }
    
    
}
