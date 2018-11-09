//
//  NewExperienceViewController+ImagePicker.swift
//  Experiences
//
//  Created by Ilgar Ilyasov on 11/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: completion)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        addPosterImageButton.setTitle("", for: [])
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else { return}
        
        DispatchQueue.global().async {
            let filteredImage = ImageFilter.apply(filter: self.coolFilter, for: image, context: self.context)
            DispatchQueue.main.async {
                self.experienceImage.image = filteredImage
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
