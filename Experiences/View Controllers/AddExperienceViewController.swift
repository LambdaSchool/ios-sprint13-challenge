//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by macbook on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class AddExperienceViewController: UIViewController {
    
    var experienceController: ExperienceController?
    var coordinates: CLLocationCoordinate2D?
    var newExperienceDelegate: NewExperienceDelegate! //MapVC

    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let title = titleTextView.text,
            let experienceController = experienceController,
            let cooordinates = coordinates else { return }
        
        let note = descriptionTextView.text
        
        experienceController.createExperience(title: title, note: note, coordinates: cooordinates)
        
        // MARK: Delegate
        newExperienceDelegate.createdExeprience(title: title)

//        NotificationCenter.default.post(name: .newLocation, object: self, userInfo: ["Location" : title])
        //    NotificationCenter.default.post(name: .blue, object: self)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func pictureButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func videoButtonTapped(_ sender: UIButton) {
        requestPermissionAndShowCamera()
    }
    
    
    // MARK: Video Access
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            
        case .notDetermined:
            // It's the first time the user has seen the dialog, we don't have permission
            requestPermission()
        case .restricted:
            // parental controls
            fatalError("Video is desabled for parental controls")
        case .denied:
            // user said no (intentionally or not
            //we asked for permission and they said no
            fatalError("Tell user they need to enable Privacy for Videio/Camera/Microphone")
        case .authorized:
            // asked for permission and they said yes
            showCamera()
        @unknown default:
            fatalError("A new status was added that we need to handle")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("User needs to enable Privacy for Video/Camera/Microphone")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.showCamera()
            }
        }
    }
    
    // setting a segue programmatically
    private func showCamera() {
        performSegue(withIdentifier: "RecordVideoSegue", sender: self)
    }
    
//    NotificationCenter.default.post(name: .blue, object: self)

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ChooseImageSegue" {
            
            if let imageVC = segue.destination as? ImageViewController {
                imageVC.experienceController = self.experienceController
            }
        }
            
        else if segue.identifier == "RecordVideoSegue" {
            
            if let videoVC = segue.destination as? VideoViewController {
                videoVC.experienceController = self.experienceController
            }
        }
    }
}

protocol NewExperienceDelegate {
    
    func createdExeprience(title: String)
}
