//
//  CameraController.swift
//  VideoRecorder
//
//  Created by Paul Solt on 10/2/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
        
	}
	
  func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "handlerToCamera" {
            let _ = segue.destination as? CameraViewController
        }
    }
    
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// TODO: get permission
		
		reequestPermissionandShowCamera()
		
	}
    
    private func reequestPermissionandShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            requestPermission() // First time we've requested access
        case .restricted: // parental controls prevent user from using the camera / microphone
            fatalError("Tell user they need to request permission from parent!")
        case .denied:
            fatalError("Tell user to enable in settings: pop up from audio to do this, or use a custom view")
        case .authorized:
            showCamera()
        default:
            fatalError("Handle new use case for authorization.")
        }
    }
    
    private func requestPermission() {
        
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Tell user to enable in settings: Popup from Audio to do this, or use a custom view.")
            }
            DispatchQueue.main.async {
                self.showCamera()
            }
        }
        
    }
    
	
	private func showCamera() {
		performSegue(withIdentifier: "cameraSegue", sender: self)
	}
}
