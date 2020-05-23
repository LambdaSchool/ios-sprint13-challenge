//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Joe on 5/23/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import AVFoundation
import UIKit

class CameraPreviewView: UIView {
  override class var layerClass: AnyClass {
    AVCaptureVideoPreviewLayer.self
  }
  var videoPlayerView: AVCaptureVideoPreviewLayer {
    layer as! AVCaptureVideoPreviewLayer
  }
  var session: AVCaptureSession? {
    get { videoPlayerView.session }
    set { videoPlayerView.session = newValue }
  }
}
