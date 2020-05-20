//
//  PhotoHelper.swift
//  Experiences
//
//  Created by Joe on 5/19/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import AVKit


extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Provides access to Photo Library
    func presentPicker(type: UIImagePickerController.SourceType) {
        let photoRoll = UIImagePickerController()
        photoRoll.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        photoRoll.sourceType = type
        present(photoRoll, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickedBlock = image
            save(photo: image)
        } else {
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
    //Inputs Monochrome Filter
    func makeBlackandWhite(photo: UIImage) {
        let context = CIContext(options: nil)
        let image = CIImage(image: photo)
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(image, forKey: "inputImage")
        filter?.setValue(CIColor.init(color: .gray), forKey: "inputColor")
        filter?.setValue(1, forKey: "inputIntensity")
        if let outputImage = filter?.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                let filteredImage = UIImage(cgImage: cgImage)
                imageView.image = filteredImage
                save(photo: filteredImage)
        }
        
    }
    
    
}
