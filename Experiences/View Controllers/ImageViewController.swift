//
//  ImageViewController.swift
//  Experiences
//
//  Created by macbook on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreImage
import Photos

class ImageViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var sephiaSlider: UISlider!
    
    private let context = CIContext(options: nil)
    private let sephiaFilter = CIFilter(name: "CISepiaTone")!  //Can Crash!
    
    private var originalImage: UIImage? {
        didSet {
            
            guard let originalImage = originalImage else { return }
            
            var scaledSize = imageView.bounds.size
            
            // Getting the scale factor :
            let scale = UIScreen.main.scale
            
            scaledSize = CGSize(width: scaledSize.width * scale,
                                height: scaledSize.height * scale)
            
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    
    private var scaledImage : UIImage? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImage = imageView.image
    }
    
    // MARK: Actions
    
    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        presentImagePicker()
    }
    
    private func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func savePhotoButtonPressed(_ sender: UIButton) {
        savePhoto()
    }
    
    private func savePhoto() {
        guard let originalImage = originalImage else {
            return //TODO: Warn the user that there is no image to save?
            
        }
        
        let processedImage = filterImage(originalImage)
        
        // save to photo library
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {
                return //TODO: Display to the user how to enable photos
                // Instructions: Go to settings, photos, pick app that you are refering to...
            }
            
            // Make a photo library change
            PHPhotoLibrary.shared().performChanges({
                
                PHAssetCreationRequest.creationRequestForAsset(from: processedImage)
                
            }) { (success, error) in
                if let error = error {
                    print("Error saving photo to library: \(error)")
                    return
                }
                
                // TODO: Display alert
                print("Saved photo successfully")
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: Slider events
    
    @IBAction func sephiaSliderChanged(_ sender: UISlider) {
        updateView()
    }
    
    
    // MARK: Private finctions
    
    private func filterImage(_ image: UIImage) -> UIImage {
        
        guard let cgImage = image.cgImage else { return image }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        // MARK: Set the filtere values
        sephiaFilter.setValue(ciImage, forKey: "inputImage")
        sephiaFilter.setValue(sephiaSlider.value, forKey: "inputIntensity")
        
        guard let outputCIImage = sephiaFilter.outputImage else { return image }
        
        let bounds = CGRect(origin: CGPoint.zero, size: image.size)
        guard let outputCGImage = context.createCGImage(outputCIImage, from: bounds) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    private func updateView() {
        
        // filter image
        if let originalImage = originalImage {
            imageView.image = filterImage(originalImage)
        } else {
            imageView.image = nil
        }
    }
    
    
}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // set the image and update the display
        
        // TODO: Play with the edited image
        
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
