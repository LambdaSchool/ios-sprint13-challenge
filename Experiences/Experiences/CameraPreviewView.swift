//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Kobe McKee on 7/11/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import AVFoundation
import UIKit

class CameraPreviewView: UIView {

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

}
