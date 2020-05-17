//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Alex Thompson on 5/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins
import MapKit

class NewExperienceViewController: ShiftableViewController {
    
    var mapVC: MapViewController?
    var userLocation: CLLocationCoordinate2D?
    private let context = CIContext()
    private let exposureAdjustFilter = CIFilter.exposureAdjust()
    private var selectedImage: UIImage? {
        didSet {
            guard let selectedImage = selectedImage else { return }
            
            var scaledSize = photoImage.bounds.size
            let scale = UIScreen.main.scale
            
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            
            let scaledUIImage = selectedImage.imageByScaling(toSize: scaledSize)
            guard let scaledCGImage = scaledUIImage?.cgImage else { return }
            
            scaledImage = CIImage(cgImage: scaledCGImage)
        }
    }
    
    private var scaledImage: CIImage? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var addPosterButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.isEnabled = false
        titleTextField.delegate = self
    }
    
    @IBAction func selectImage(_ sender: UIButton) {

        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library.")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library you must allow us to access it.")
                    return
                }
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow us to access it.")
            
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. You're device's restrictions do not allow access")
        @unknown default:
            preconditionFailure("The app does not handle this new case provided by apple.")
        }
        presentImagePickerController()
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        
        guard titleTextField.text != "" else {
            presentInformationalAlertController(title: "Error", message: "Cannot have text field empty")
            
            return
        }
        
        performSegue(withIdentifier: "RecordSegue", sender: self)
    }
    
    
    
    private func updateViews() {
        if let scaledImage = scaledImage {
            photoImage.image = filterImage(for: scaledImage)
        } else {
            photoImage.image = nil
        }
    }
    
    private func filterImage(for inputImage: CIImage) -> UIImage {
        
        exposureAdjustFilter.inputImage = inputImage
        exposureAdjustFilter.ev = Float(1.0)
        
        guard let outputImage = exposureAdjustFilter.outputImage else { return UIImage(ciImage: inputImage)}
        
        guard let renderedImage = context.createCGImage(outputImage, from: CGRect(origin: CGPoint.zero, size: UIImage(ciImage: inputImage).size)) else { return UIImage(ciImage: inputImage)}
        
        return UIImage(cgImage: renderedImage)
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordSegue" {
            guard let audioRecordingVC = segue.destination as? AudioRecordingViewController else { return }
            
            guard let image = photoImage.image else { return }
            
            let picture = Experience.Picture(imagePost: image)
            
            audioRecordingVC.experienceTitle = titleTextField.text
            audioRecordingVC.picture = picture
            audioRecordingVC.userLocation = userLocation
            audioRecordingVC.mapViewController = mapVC
        }
    }
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        addPosterButton.setTitle("", for: [])
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        selectedImage = image
        recordButton.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
