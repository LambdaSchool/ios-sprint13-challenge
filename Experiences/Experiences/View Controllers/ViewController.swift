//
//  ViewController.swift
//  Experiences
//
//  Created by denis cedeno on 5/18/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var experience: Experience?
    var UUIDString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestPermissionAndShowCamera()
    }
    
    private func requestPermissionAndShowCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            requestVideoPermission()
            
        case .restricted: // Parental controls, for instance, are preventing recording
            preconditionFailure("Video is disabled, please review device restrictions")
            
        case .denied:
            preconditionFailure("Tell the user they can't use the app without giving permissions via Settings > Privacy > Video")
            
        case .authorized:
            showCamera()
            
        @unknown default:
            preconditionFailure("A new statuc code was added that we need to handle")
        }
    }
    
    private func requestVideoPermission() {
        AVCaptureDevice.requestAccess(for: .video) { isGranted in
            guard isGranted else {
                preconditionFailure("UI: Tell the user to enable permissions for Video/Camera")
            }
            
            DispatchQueue.main.async {
                self.showCamera()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let videoVC = segue.destination as? VideoViewController else { return }
        videoVC.UUIDString = self.UUIDString
        videoVC.experience = self.experience
    }
    
    private func showCamera() {
        performSegue(withIdentifier: "ShowCamera", sender: self)
        
        }
        
    }

