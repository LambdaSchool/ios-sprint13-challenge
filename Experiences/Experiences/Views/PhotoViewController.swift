//
//  PhotoViewController.swift
//  Experiences
//
//  Created by Kevin Stewart on 7/17/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class PhotoViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageSlider: UISlider!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var choosePhotoButton: UIBarButtonItem!
    
    //MARK: - Properties and computed properties
        var origionalImage: UIImage? {
            didSet {
                guard let origionalImage = origionalImage else {
                    scaledImage = nil
                    return
                }
                
                let scale = UIScreen.main.scale
                
                var scaledSize = imageView.bounds.size
                scaledSize = CGSize(width: scaledSize.width * scale,
                                    height: scaledSize.height * scale)
                guard let scaledUIImage = origionalImage.imageByScaling(toSize: scaledSize) else {
                    scaledImage = nil
                    return
                }
                
                scaledImage = CIImage(image: scaledUIImage)
            }
        }
        
        var scaledImage: CIImage? {
            didSet {
                updateImage()
            }
        }
    
    private let context = CIContext()
    private let sepiaToneFilter = CIFilter.sepiaTone()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origionalImage = imageView.image
    }
    
    //MARK: - Methods
    private func image(byFiltering inputImage: CIImage) -> UIImage? {
        sepiaToneFilter.inputImage = inputImage
        sepiaToneFilter.intensity = imageSlider.value
            
            guard let outputImage = sepiaToneFilter.outputImage else { return nil }
            guard let renderCGImage = context.createCGImage(outputImage, from: inputImage.extent) else { return nil }
            
            return UIImage(cgImage: renderCGImage)
        }
        
        private func updateImage() {
            if let scaledImage = scaledImage {
                imageView.image = image(byFiltering: scaledImage)
            } else {
                imageView.image = nil
            }
        }
        
        private func presentImagePickerController() {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print("Could not access photo library.")
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
            guard let originalImage = origionalImage?.flattened,
                let ciImage = CIImage(image: originalImage) else { return }
            
            guard let processedImage = image(byFiltering: ciImage) else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: processedImage)
            }) { (success, error) in
                if let error = error {
                    print("Error saving photo: \(error)")
                    return
                } else {
                    DispatchQueue.main.async {
                        self.presentSuccessfulSaveAlert()
                    }
                }
            }
        }
        
        private func presentSuccessfulSaveAlert() {
             let alert = UIAlertController(title: "Photo Saved!", message: "The photo has been saved to your Photo Library!", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
             present(alert, animated: true, completion: nil)
         }

        // MARK: Slider events
        
        @IBAction func brightnessChanged(_ sender: UISlider) {
            updateImage()
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

    extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                origionalImage = image
            } else if let image = info[.originalImage] as? UIImage {
                origionalImage = image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
