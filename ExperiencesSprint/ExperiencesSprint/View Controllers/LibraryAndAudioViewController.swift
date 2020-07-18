//
//  LibraryAndAudioViewController.swift
//  ExperiencesSprint
//
//  Created by Jarren Campos on 7/17/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class LibraryAndAudioViewController: UIViewController {
    
    var pictureChanged: Bool = false
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chooseImageButton: UIButton!
    @IBOutlet var changeCurrentImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeCurrentImage.alpha = 0
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func presentFailureAlert() {
        let alert = UIAlertController(title: "Failure", message: "Please add an image first.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func changeCurrentPicturePressed(_ sender: Any) {
        presentImagePickerController()
    }
    @IBAction func nextNavBarButtonPressed(_ sender: Any) {
        if pictureChanged == true {
            performSegue(withIdentifier: "toCreatePostVC", sender: UIButton.self)
        } else {
            presentFailureAlert()
        }
    }
    
}

extension LibraryAndAudioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
       if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            self.chooseImageButton.alpha = 0
            self.changeCurrentImage.alpha = 1
            self.pictureChanged = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
