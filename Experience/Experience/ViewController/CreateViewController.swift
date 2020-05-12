//
//  CreateViewController.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class CreateViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    var locationManager = CLLocationManager()
    
    var experiences: Experiences?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
    }
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
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
        let lat = locationManager.location?.coordinate.latitude ?? 00
        let long = locationManager.location?.coordinate.longitude ?? 00
        experiences?.create(title: title, latitude: lat, longitude: long)
        navigationController?.popViewController(animated: true)
    }
    
}
extension CreateViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        locationManager.requestLocation()
    }
}
