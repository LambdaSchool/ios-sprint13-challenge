//
//  CreateExperienceViewController.swift
//  ExperiencesWorkingDraft
//
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
import AVFoundation

class CreateExperienceViewController: UIViewController {
    //MARK: - Properties -
    var experienceController = ExperienceController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .addVideoSegue {
            guard let addVideoVC = segue.destination as?
                AddVideoViewController else { return }
            addVideoVC.videoDelegate = self.experienceController
            
        }
    }
    
    
    //MARK: - Methods -
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            showCamera()
        case .denied:
            fatalError("Camera Permission Denied")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    fatalError("Camera permission denied.")
                }
                DispatchQueue.main.async {
                    self.showCamera()
                }
            }
        case .restricted:
            fatalError("Camera Permission Restricted")
        @unknown default:
            fatalError("Unknown system state. Permission value not handled.")
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: .addVideoSegue, sender: self)
    }

}
