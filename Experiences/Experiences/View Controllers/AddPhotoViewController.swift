//
//  AddPhotoViewController.swift
//  Experiences
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
import Photos

//TODO: Create filtering method.

class AddPhotoViewController: UIViewController {
    //MARK: - Properties -
    @IBOutlet weak var currentImage: UIImageView!
    
    var photoDelegate: PhotoAdderDelegate?
    var image: UIImage?
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        presentImagePicker()
    }
    
    //MARK: - Actions -
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        guard let image = image else { return }
        //call filter image function as property to get filtered image
        let filteredImage = sharpen(image)
        //make current image filtered image
        self.image = filteredImage
        self.currentImage.image = self.image
    }
    @IBAction func pickerButtonTapped(_ sender: UIButton) {
        presentImagePicker()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let image = image {
            photoDelegate?.addPhoto(image)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods -
    private func presentImagePicker() {
        //make sure the photo library is available
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is not available.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func sharpen(_ image: UIImage) -> UIImage {
        let sharpen = 
        sha
    }
    
}

extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.image = selectedImage
            self.currentImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
