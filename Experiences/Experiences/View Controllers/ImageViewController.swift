//
//  ImageViewController.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/17/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import UIKit
import CoreImage
import CoreData
import Photos
import AssetsLibrary

class ImageViewController: UIViewController {
    
    var experienceLocation: CLLocation?
    
    var date = Date()
    
    var df: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "h:mm:ss | LLL dd, yyyy"
        return formatter
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var imageTitleTextField: UITextField!
    @IBOutlet weak var brightnessSider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            // Height and width
            var scaledSize = imageView.bounds.size
            // 1x, 2x, or 3x
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            print("size: \(scaledSize)")
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    // Grab filter we're using
    private var filter = CIFilter(name: "CIColorControls")! //force unwrapped just for the lecture
    
    // Create a helper to do our rendering for us.
    private var context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give me the image out of the storyboard as the original image
        originalImage = imageView.image
        print("View Loaded With:", experienceLocation)
    }
    
    // Helper function
    private func filterImage(_ image: UIImage) -> UIImage {
        
        //return the original image if something isn't working
        guard let cgImage = image.cgImage else { return image }
        
        // setup the filter using a dictionary
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey) //input image
        filter.setValue(brightnessSider.value, forKey: kCIInputBrightnessKey)
        filter.setValue(contrastSlider.value, forKey: kCIInputContrastKey)
        filter.setValue(saturationSlider.value, forKey: kCIInputSaturationKey)
        
        guard let outputCIImage = filter.outputImage else { return image }
        
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return image }
        
        
        return UIImage(cgImage: outputCGImage)
    }
    
    // MARK: Actions
    
    @IBAction func selectPhotoTapped(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        saveImageToCoreData()
        
        guard let originalImage = originalImage else { return }
        let processedImage = filterImage(originalImage.flattened)
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: processedImage)
                
            }, completionHandler: { (success, error) in
                if let error = error {
                    NSLog("Error saving photo: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    print("Saved image!")
                    
                }
            })
        }
        
        
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    // helper function to present image picker
    private func presentImagePickerController() {
        // look for the photo library
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The source type is unavailable.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    let experienceURL = { () -> URL in
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("jpg")
        
        return fileURL
    }
    
    
    
    // MARK: Slider events
    
    
    @IBAction func brightnessChanged(_ sender: Any) {
        updateImage()
    }
    
    @IBAction func contrastChanged(_ sender: Any) {
        updateImage()
    }
    @IBAction func saturationChanged(_ sender: Any) {
        updateImage()
    }
    
    // function to apply to all three function
    private func updateImage() {
        //upwrap the original image
        if let scaledImage = scaledImage {
            imageView.image = filterImage(scaledImage)
        } else {
            imageView.image = nil
        }
    }
    
    func saveImageToCoreData() {
        let experience = Experience(context: CoreDataStack.context)
        
        guard let experienceLocation = self.experienceLocation else { return }
        
        let latitude = Double(experienceLocation.coordinate.latitude)
        let longitude = Double(experienceLocation.coordinate.longitude)
        
        
        experience.title = imageTitleTextField.text
        experience.latitude = latitude
        experience.longitude = longitude
        experience.mediaURL = experienceURL()
        experience.mediaType = ".jpg"
        experience.date = Date.currentTimeStamp
        
        print(self.experienceURL)
        
        CoreDataStack.saveContext()
    }
}

extension ImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        imageTitleTextField.resignFirstResponder()
        
        return true
    }
}

extension ImageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImageViewController: UINavigationControllerDelegate {
    
}
