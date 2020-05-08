//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Wyatt Harrell on 5/8/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

extension UIViewController {
    func hideKeyboardWhenViewTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

class AddExperienceViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    let locationManager = CLLocationManager()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        self.hideKeyboardWhenViewTapped()
        setupViews()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        titleTextField.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
        titleTextField.setLeftPaddingPoints(10)
    }
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            case .notDetermined:
                requestPermission()
            case .restricted:
                fatalError("Tell user they need to reqquest permission from parent (UIAlert)")
            case .denied:
                fatalError("Tell the user to enable in settings")
            case .authorized:
                showCamera()
            default:
                fatalError("Handle new case for authorization")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (isGranted) in
            guard isGranted else { fatalError("Tell the user to enable in settings") }
            
            DispatchQueue.main.async {
                self.showCamera()
            }
        }
    }
    
    private func showCamera() {
        performSegue(withIdentifier: "ShowCameraSegue", sender: self)
    }
    
    // MARK: - IBActions
    
    @IBAction func recordAudioButtoTapped(_ sender: Any) {
    }
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
    }
    
    @IBAction func recordVideoButtonTapped(_ sender: Any) {
        requestPermissionAndShowCamera()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
