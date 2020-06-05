//
//  CameraPreviewView.swift
//  SprintChallengeExperience
//
//  Created by Jerry haaser on 1/17/20.
//  Copyright © 2020 Jerry haaser. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
