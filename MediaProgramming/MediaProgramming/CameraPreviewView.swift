//
//  CameraPreviewView.swift
//  MediaProgramming
//
//  Created by Yvette Zhukovsky on 1/18/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import Foundation
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
