//
//  CameraPreviewView.swift
//  Experience
//
//  Created by Carolyn Lea on 10/19/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView
{
    var videoPreviewLayer: AVCaptureVideoPreviewLayer
    {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override class var layerClass: AnyClass
    {
        return AVCaptureVideoPreviewLayer.self
    }
    
}
