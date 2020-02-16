//
//  CameraView.swift
//  Experiences
//
//  Created by brian vilchez on 2/15/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {

 override class var layerClass: AnyClass {
       return AVCaptureVideoPreviewLayer.self
   }
   
   var videoPlayerView: AVCaptureVideoPreviewLayer {
       return layer as! AVCaptureVideoPreviewLayer
   }
   
   var session: AVCaptureSession? {
       get { return videoPlayerView.session }
       set { videoPlayerView.session = newValue }
   }
}
