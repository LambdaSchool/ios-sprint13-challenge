//
//  VideoHelper.swift
//  Experiences
//
//  Created by Joe on 5/19/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import AVFoundation
import UIKit

extension AddExperienceViewController {
    func requestPermissionAndShowCamera() {

    let status = AVCaptureDevice.authorizationStatus(for: .video)
    
    switch status {
        
    case .notDetermined:
        // First time user has seen the dialog, we don't have permission
        requestPermission()
    case .restricted:
        // parental controls
        alertMessage(title: "Restricted", message: "Video is disabled for parental controls")
        fatalError("Video is disabled for parental controls")
        
    case .denied:
        // we asked for permission and they said no
        alertMessage(title: "Denied", message: "Tell user they need to enable Privacy for Video/Camera/Microphone")
        fatalError("Tell user they need to enable Privacy for Video/Camera/Microphone")
        
    case .authorized:
        // we asked for permission and they said yes
        
        showCamera()
    default:
        alertMessage(title: "Unknown Error", message: "A new status was added that we need to handle")
        fatalError("A new status was added that we need to handle")
        
        }
    }
    
    private func requestPermission() {
    AVCaptureDevice.requestAccess(for: .video) { (granted) in
        guard granted else {
            self.alertMessage(title: "Error.", message: "Tell user they need to enable Privacy for Video/Camera/Microphone")
            fatalError("Tell user they need to enable Privacy for Video/Camera/Microphone")
        }
        DispatchQueue.main.async { [weak self] in
            self?.showCamera()
            }
        }
    }
    
    func showCamera() {
        performSegue(withIdentifier: "ToAVCapture", sender: self)
    }
}
