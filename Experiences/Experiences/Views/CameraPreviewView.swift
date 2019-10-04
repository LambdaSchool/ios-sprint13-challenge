//
//  CameraPreviewView.swift
//  iOS6-VideoRecorder
//
//  Created by Paul Solt on 7/10/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//
//swiftlint:disable force_cast

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
		set {
			videoPlayerLayer.session = newValue
			videoPlayerLayer.videoGravity = .resizeAspectFill
		}
	}
}
