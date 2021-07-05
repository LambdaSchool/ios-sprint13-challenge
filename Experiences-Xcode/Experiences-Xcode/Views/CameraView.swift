//
//  CameraView.swift
//  Experiences-Xcode
//
//  Created by Austin Potts on 3/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
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
