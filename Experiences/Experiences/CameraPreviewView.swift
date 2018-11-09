//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Daniela Parra on 11/9/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
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
