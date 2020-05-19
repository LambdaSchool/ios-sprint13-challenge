//
//  landingPageViewController.swift
//  Experiences
//
//  Created by denis cedeno on 5/15/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import MapKit

class landingPageViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var viewJournalButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nextVideoButton: UIBarButtonItem!
    
    @IBAction func addImage(_ sender: Any) {
        presentImagePickerController()
    }
    @IBAction func nextButton(_ sender: Any) {
        saveExperience()
    }
    
    var experience: Experience?
    let experienceController = ExperiencesController()
    var locationManager = CLLocationManager()
    var latitude: Double = 0
    var longitude: Double = 0
    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            var scaledSize = imageView.bounds.size
            let scale: CGFloat = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width*scale,
                                height: scaledSize.height*scale)
            guard let scaledUIImage = originalImage.imageByScaling(toSize: scaledSize) else { return }
            scaledImage = CIImage(image: scaledUIImage)
        }
    }
    
    var scaledImage: CIImage? {
        didSet {
            updateImage()
        }
    }
    
    private let context = CIContext()
    private let colorControlsFilter = CIFilter.colorControls()
    private let blackAndWhiteFilter = CIFilter.colorMonochrome()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        originalImage = imageView.image
    }
    
    private func image(byFiltering inputImage: CIImage) -> UIImage {
        colorControlsFilter.inputImage = inputImage
        blackAndWhiteFilter.inputImage = colorControlsFilter.outputImage?.clampedToExtent()
        blackAndWhiteFilter.color = .gray
        blackAndWhiteFilter.intensity = 1
        
        guard let outputImage = blackAndWhiteFilter.outputImage else { return originalImage! }
        guard let renderedImage = context.createCGImage(outputImage, from: inputImage.extent) else { return originalImage! }
        
        return UIImage(cgImage: renderedImage)
    }
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            imageView.image = image(byFiltering: scaledImage)
        } else {
            imageView.image = nil
        }
    }
    
    private func saveExperience() {
        updateImage()
        guard let originalImage = originalImage?.flattened,
            let title = titleTextField.text,
            let ciImage = CIImage(image: originalImage) else { return }
        
        let processedImage = self.image(byFiltering: ciImage)
        guard let imageData = processedImage.pngData() else {return}
        
        experience = Experience(image: imageData, title: title, uuid: UUID(), latitude: latitude, longitide: longitude)

        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: processedImage)
            }) { (success, error) in
                if let error = error {
                    print("Error saving photo: \(error)")
                    return
                }
            }
        }
    }
    
    @objc private func addImage() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    return
                }
                self.presentImagePickerController()
            }
        default:
            break
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordingNextSegue" {
            guard let recordingVC = segue.destination as? AudioViewController else { return }
            saveExperience()
            recordingVC.experience = self.experience
        } else if segue.identifier == "RecordSegue" {
            guard let recordVC = segue.destination as? AudioViewController else { return }
            saveExperience()
            recordVC.experience = self.experience
        }
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}


extension landingPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension landingPageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = coordinates.latitude
        longitude = coordinates.longitude
    }
}
