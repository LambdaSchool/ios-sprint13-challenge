//
//  CameraPreviewView.swift
//  ios-sprint-challenge13
//
//  Created by David Doswell on 10/19/18.
//  Copyright © 2018 David Doswell. All rights reserved.
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
