//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Vuk Radosavljevic on 10/19/18.
//  Copyright © 2018 Vuk. All rights reserved.
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
