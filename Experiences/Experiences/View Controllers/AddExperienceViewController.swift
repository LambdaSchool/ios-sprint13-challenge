//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Dillon P on 3/22/20.
//  Copyright © 2020 Lambda iOSPT3. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

class AddExperienceViewController: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    
    // MARK: - Properties
    
    var originalImage: UIImage? {
        didSet {
            imageView.image = makeImageBW(byFiltering: originalImage!)
        }
    }
    
    
    //MARK: - View Set-Up

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Image Picker Methods
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            preconditionFailure("Photo Library not available")
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Image Filtering Methods
    
    private let context = CIContext()
    private let bwFilter = CIFilter.photoEffectMono()
    
    func makeImageBW(byFiltering image: UIImage) -> UIImage {
        // 1. UI Image -> CG Image
        guard let cgImage = image.cgImage else {
            print("Couldn't get CGImage from UIImage input")
            return image
        }
        // 2a. CGImage -> CIImage as filter input
        let inputImage = CIImage(cgImage: cgImage)
        // 2b. Filter CIImage
        bwFilter.inputImage = inputImage
        // 2c. CIImage as filter output
        guard let outputImage = bwFilter.outputImage else {
            print("Unable to get filter output image")
            return image
        }
        // 3. Render filtered output CIImage to a CGImage
        guard let renderedImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            print("Unable to render chrome filtered image")
            return image
        }
        // 4. Return UIImage
        return UIImage(cgImage: renderedImage)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func choosImageButtonTapped(_ sender: Any) {
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
            
        case .denied:
            let alert = UIAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.", preferredStyle: .alert)
            self.present(alert, animated: true)
        case .restricted:
            let alert = UIAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.", preferredStyle: .alert)
            self.present(alert, animated: true)
        @unknown default:
            return
        }
        presentImagePickerController()
    }

    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: Any) {
    }
    
}


//MARK: - Image Picker Delegate Extension

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chooseImageButton.setTitle("", for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            originalImage = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
