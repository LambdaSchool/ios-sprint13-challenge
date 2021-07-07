//
//  CameraPreviewView.swift
//  VideoFilters
//
//  Created by Scott Bennett on 11/7/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    
    // Override class so returns preview layer instead of normal layer for smooth video playback
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

/* This is a computed property so we don't have to cast to AVCaptureVideoPreviewLayer everytime we call the video preview layer, also force cast because there should always work so something is really wrong if it doesn't
*/
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

}
