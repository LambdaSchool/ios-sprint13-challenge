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
    var geotag: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        checkLocationAuthorization()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        getUserLocation()
        
        guard let title = titleTextView.text,
            let experienceController = experienceController,
            let geotag = geotag else { return }
        
        let note = descriptionTextView.text
        
        experienceController.createExperience(title: title, note: note, geotag: geotag)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func pictureButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func videoButtonTapped(_ sender: UIButton) {
        requestPermissionAndShowCamera()
    }
    
    func getUserLocation() {
        
        if let location = locationManager.location?.coordinate {
            self.geotag = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation() // Updates location as it moves

//        locationManager.requestAlwaysAuthorization()
//        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse :
            setupLocationManager()

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // asking fro permission
        case .restricted:
            // TODO: Show alert letting know whats up
            break
        case .denied:
            // TODO: Show alert instructing them how to turn on permission
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
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

extension AddExperienceViewController: CLLocationManagerDelegate {
    
    // This func runs every time the user moves (re-locates)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
    }
    
    
    // Runs everytime the authirization changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
