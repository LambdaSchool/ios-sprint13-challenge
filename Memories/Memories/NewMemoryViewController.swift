//
//  NewMemoryViewController.swift
//  Memories
//
//  Created by Samantha Gatt on 10/19/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

class NewMemoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private let filter = CIFilter(name: "CISepiaTone")!
    private let context = CIContext(options: nil)
    
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var addPhotoButton: UIButton!
    @IBOutlet private weak var recordStopButton: UIButton!
    @IBOutlet private weak var playbackButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction private func addPhoto(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[.originalImage] as? UIImage
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(1, forKey: kCIInputIntensityKey)
        
        guard let outputCIImage = filter.outputImage,
            let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return }
        
        imageView.image = UIImage(cgImage: outputCGImage)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
