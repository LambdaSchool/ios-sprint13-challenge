//
//  CreateViewController.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import AVFoundation


class CreateViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!

    var experiences: Experiences?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addVideoTapped(_ sender: Any) {
        requestPermissionAndShowCamera()
    }
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            case .notDetermined:  // first time we've requested access
                requestPermission()
            case .restricted: // parental controls prevent user from using the camera / microphone
                fatalError("Tell user they need to request permission from parent (UI)")
            case .denied:
                fatalError("Tell user to enable in Settings: Popup from Audio to do this, or use a custom view")
            case .authorized:
                showCamera()
            default:
                fatalError("Handle new case for authorization")
        }
    }
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Tell user to enable in Settings: Popup from Audio to do this, or use a custom view")
            }
            DispatchQueue.main.async {
                self.showCamera()
            }
        }
    }

    private func showCamera() {
        self.performSegue(withIdentifier: "ShowCamera", sender: self)
    }
    
    
    @IBAction func saveExp(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {return}
        experiences?.create(title: title, latitude: Double(Int.random(in: 47_200_953...48_083_626)) / 1_000_000, longitude: Double(Int.random(in: (-122_564_484)...(-121_963_246))) / 1_000_000)
        navigationController?.popViewController(animated: true)
        //experience?.lat =
    }
}
