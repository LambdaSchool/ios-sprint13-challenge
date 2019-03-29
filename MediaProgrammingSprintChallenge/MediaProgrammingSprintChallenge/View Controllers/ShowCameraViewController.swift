//
//  ShowCameraViewController.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit
import AVFoundation

class ShowCameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status == false {
                    fatalError()
                }
                DispatchQueue.main.async {
                    self.showCamera()
                }
            }
            
        case .restricted:
            fatalError()
        case .denied:
            fatalError()
        case .authorized:
            showCamera()
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: "ShowCamera", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCamera" {
            guard let cameraVC = segue.destination as? CameraViewController,
                let audioURL = audioURL, let imageURL = imageURL,
                let caption = caption, let momentController = momentController,
                let longitude = longitude,
                let latitude = latitude else { return }
            
            cameraVC.audioURL = audioURL
            cameraVC.imageURL = imageURL
            cameraVC.caption = caption
            cameraVC.momentController = momentController
            cameraVC.longitude = longitude
            cameraVC.latitude = latitude
        }
    }
    
    var audioURL: URL?
    var imageURL: URL?
    var caption: String?
    var longitude: Double?
    var latitude: Double?
    var momentController: MomentController?
}
