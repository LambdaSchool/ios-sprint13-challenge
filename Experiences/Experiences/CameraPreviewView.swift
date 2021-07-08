//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Sean Hendrix on 1/18/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
//

import UIKit
import AVFoundation
class CameraPreviewView: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
}
