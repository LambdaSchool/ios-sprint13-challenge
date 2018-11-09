//
//  CameraPreviewView.swift
//  VideoFilter
//
//  Created by Farhan on 11/7/18.
//  Copyright © 2018 Farhan. All rights reserved.
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
