//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Gerardo Hernandez on 5/26/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    
     override class var layerClass: AnyClass {
           return AVCaptureVideoPreviewLayer.self
       }
       
       var videoPlayerLayer: AVCaptureVideoPreviewLayer {
           return layer as! AVCaptureVideoPreviewLayer
       }
       
       var session: AVCaptureSession? {
           get { return videoPlayerLayer.session }
           set { videoPlayerLayer.session = newValue }
       }
}
