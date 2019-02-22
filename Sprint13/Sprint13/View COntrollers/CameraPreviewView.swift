//
//  CameraPreviewView.swift
//  VideoRecorder
//
//  Created by Sergey Osipyan on 2/20/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

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
