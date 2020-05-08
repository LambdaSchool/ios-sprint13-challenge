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
import CoreImage

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
    @IBOutlet weak var recordVideoButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    // MARK: - Properties
    var experienceController: ExperienceController?
    let locationManager = CLLocationManager()
    let context = CIContext(options: nil)
    var recordedVideoURL: URL?
    
    var originalImage: UIImage? {
        didSet {
            selectPhotoButton.setTitle("", for: .normal) // To allow the user to still select a different image
            updateImageView()
        }
    }

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
        presentImagePickerController()
    }
    
    @IBAction func recordVideoButtonTapped(_ sender: Any) {
        requestPermissionAndShowCamera()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        //TODO: FINISH THIS ACTION
        experienceController?.createExperience(name: title, image: imageView.image, audioURL: nil, videoURL: recordedVideoURL, longitude: 0, latitude: 0)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCameraSegue" {
            guard let RecordVideoVC = segue.destination as? RecordVideoViewController else { return }
            RecordVideoVC.delegate = self
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Photo Experience
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: The photo library is not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func updateImageView() {
        if let originalImage = originalImage {
             imageView.image = filterImage(originalImage)
         } else {
             imageView.image = nil
         }
    }

    private func filterImage(_ image: UIImage) -> UIImage? {
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
                
        // Filter
        let filter = CIFilter(name: "CISepiaTone")!
        
        // Setting values / getting values from Core Image
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.75, forKey: kCIInputIntensityKey)
        
        // CIImage -> CGImage -> UIImage
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        // Render the image (do image processing here). Recipe needs to be used on image now.
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else {
            return nil
        }
        
        return UIImage(cgImage: outputCGImage)
    }
}

extension AddExperienceViewController: RecordedVideoURLDelegate {
    func recordedVideoURL(url: URL) {
        recordedVideoURL = url
        recordVideoButton.isSelected = true
    }
}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
