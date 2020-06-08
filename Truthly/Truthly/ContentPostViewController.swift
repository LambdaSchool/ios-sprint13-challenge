//
//  ContentPostViewController.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ContentPostViewController: UIViewController {

        //MARK: Properties -
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
        
        private var originalImage: UIImage?
        
        private var scaledImage: UIImage? {
            didSet {
                updateViews()
            }
        }
        
        private let context = CIContext(options: nil)
        
        //MARK: Outlets -
        
 
        @IBOutlet weak var photoImageView: UIImageView!
        //MARK: IBActions -
        @IBAction func slider1(_ sender: UISlider) {
            updateViews()
        }
        @IBAction func slider2(_ sender: Any) {
            updateViews()
        }
        @IBAction func slider3(_ sender: Any) {
            updateViews()
        }
        @IBAction func slider4(_ sender: Any) {
            updateViews()
        }
        @IBAction func slider5(_ sender: Any) {
            updateViews()
        }
        @IBAction func addPhotoButtonPressed(_ sender: Any) {
            presentImagePickerController()
        }
        @IBAction func savePhotoButtonPressed(_ sender: Any) {
            savePhoto()
        }
        
        //MARK: Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
    
            originalImage = photoImageView.image
        }
        
        func updateViews() {
            if scaledImage != nil {
                photoImageView.image = originalImage
                post?.image = photoImageView.image
            } else {
                photoImageView.image = nil
            }
        }
        
        //MARK: Methods -
    
        private func presentImagePickerController() {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print("Error: The photo library is not available")
                return
            }
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }

        
        private func savePhoto() {
            guard let originalImage = originalImage else { return }
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else { return }
                
                PHPhotoLibrary.shared().performChanges({
                    
                    PHAssetCreationRequest.creationRequestForAsset(from: originalImage)
                    
                }) { success, error in
                    if let error = error {
                        print("Error saving photo: \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        print("Saved photo")
                    }
                }
            }
        }
    }

    extension ContentPostViewController: UIImagePickerControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                originalImage = image
                photoImageView.image = originalImage
                
            }
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    extension ContentPostViewController: UINavigationControllerDelegate {
    
    }
