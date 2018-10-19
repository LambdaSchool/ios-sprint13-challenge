//
//  CameraPreview.swift
//  VideoFilters
//
//  Created by Simon Elhoej Steinmejer on 17.10.18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreview: UIView
{
    override class var layerClass: AnyClass
    {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer
    {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
