//
//  PhotoFilterViewController.swift
//  ImageManipulator
//
//  Created by Lambda_School_Loaner_268 on 5/4/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import Foundation

class DiscBlurViewController: UIViewController {

    let context = CIContext(options: nil)
    
    var originalImage: UIImage? {
        didSet {
            // resize the scaledImage and set it
            guard let originalImage = originalImage else { return }
            
            // Height and width
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale  // 1x, 2x, or 3x
            
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            print("scaled size: \(scaledSize)")
            
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
        
    var scaledImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        originalImage = imageView.image
    }
    
    // filterImage(originalImage)

    // Create a stub with default return is a good way to start
    private func filterImage(_ image: UIImage) -> UIImage? {
        
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        // TODO: show builtins filters
        
        // Filter image
    // built-in filter from Apple
//        let filter2 = CIFilter.colorControls()
//        filter2.brightness = brightnessSlider.value
        
        // setting values / gebttings values from Core Image
        var filter = CIFilter(name: "CIDiscBlur")
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(radiusSlider.value, forKey: kCIInputRadiusKey)
        
        
        // CIImage -> CGImage -> UIImage
        
        // guard let outputCIImage = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        guard let outputCIImage = filter?.outputImage else { return nil }
        
        // Render the image (do image processing here)
        guard let outputCGImage = context.createCGImage(outputCIImage,
                                                        from: CGRect(origin: .zero, size: image.size)) else {
            return nil
        }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    private func updateViews() {
        if let scaledImage = scaledImage {
            imageView.image = filterImage(scaledImage)
        } else {
           imageView.image = nil
        }
    }
    
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
    
    // MARK: Actions
    
    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func savePhotoButtonPressed(_ sender: UIButton) {
        guard let originalImage = originalImage else { return }
        
        guard let processedImage = filterImage(originalImage.flattened) else { return }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            guard status == .authorized else { return }
            
            // Let the library know we are going to make changes
            PHPhotoLibrary.shared().performChanges({
                
                // Make a new photo creation request
                
                PHAssetCreationRequest.creationRequestForAsset(from: processedImage)
                
            }, completionHandler: { (success, error) in
                
                if let error = error {
                    NSLog("Error saving photo: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.presentSuccessfulSaveAlert()
                }
            })
        }
    }

    private func presentSuccessfulSaveAlert() {
        let alert = UIAlertController(title: "Photo Saved!", message: "The photo has been saved to your Photo Library!", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okayAction)
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: Slider events
    
    @IBAction func radiusChanged(_ sender: UISlider) {
        updateViews()
    }
    
}


extension DiscBlurViewController: UIImagePickerControllerDelegate {
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

extension DiscBlurViewController: UINavigationControllerDelegate {
    
}

