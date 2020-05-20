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
        photoRoll.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
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
    //Filter removes Color
    func makeBlackandWhite(photo: UIImage) {
        let image = CIImage(image: photo)
        guard let new = image else { return }
        let blackAndWhiteImage = new.applyingFilter("CIColorControls", parameters: ["inputSaturation": 0, "inputContrast": 3, "InputBrightness": 1])
        let savedImage =  UIImage(ciImage: blackAndWhiteImage)
                save(photo: savedImage)
    }
}
