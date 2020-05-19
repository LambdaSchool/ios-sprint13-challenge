//
//  PhotoHelper.swift
//  Experiences
//
//  Created by Joe on 5/19/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import AVKit


extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickedBlock = image
            save(photo: image)
        }else{
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
}
