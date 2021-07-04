//
//  CameraPreviewView.swift
//  ChallengeExperience2
//
//  Created by Michael Flowers on 9/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit
import AVFoundation

//this class will help us get the live, preview view
class CameraPreviewView: UIView {
    
    override class var layerClass: AnyClass {
        //the view that displays the camera recording
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPlayerView: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    //real time viewing
    var session: AVCaptureSession? {
        get { return videoPlayerView.session }
        set { return videoPlayerView.session = newValue }
    }
    
}
