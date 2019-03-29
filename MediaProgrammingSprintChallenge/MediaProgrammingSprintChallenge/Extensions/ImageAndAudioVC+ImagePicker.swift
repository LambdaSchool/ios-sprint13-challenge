//
//  ImageAndAudioVC+ImagePicker.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit

extension ImageAndAudioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func image(byFiltering image: UIImage) -> UIImage {
        
        guard let cgImage = image.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter.outputImage else { return image }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    func presentImagePicker() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Photo library unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func resize(image: UIImage, toSize size: CGSize) -> UIImage? {
        var scaledSize = size
        let scale = UIScreen.main.scale
        scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
        return image.imageByScaling(toSize: scaledSize)
    }
    
    func updateImage() {
        if let scaledImage = scaledImage {
            imageView.image = invertSwitch.isOn ? image(byFiltering: scaledImage) : scaledImage
        } else {
            imageView.image = nil
        }
    }
    
    // MARK: - Delegate functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        originalImage = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
