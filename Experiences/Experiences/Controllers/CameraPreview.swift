//
//  CameraPreview.swift
//  Experiences
//
//  Created by Craig Belinfante on 11/8/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import Foundation
import AVFoundation
import MapKit

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
