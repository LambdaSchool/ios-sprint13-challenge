//
//  PictureViewController.swift
//  Experiences
//
//  Created by brian vilchez on 2/14/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

class PictureViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var blurSLider: UISlider!
    @IBOutlet weak var secondSlider: UISlider!
    @IBOutlet weak var thirdSlider: UISlider!
    var originalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func photosIconPressed(_ sender: Any) {
        presentActionSheet()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func blurSliderMoved(_ sender: UISlider) {
        
    }
    
    @IBAction func secondSLiderMoved(_ sender: UISlider) {
        
    }
    
    @IBAction func thirdSliderMoved(_ sender: UISlider) {
        
    }
    
    // MARK - Helper Methods
    private func updateImage() {
        
    }
    
    private func presentActionSheet() {
        let alertVC = UIAlertController(title: "Choose option", message: "", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.camera()
        }
        
        let photoLibraryAction = UIAlertAction(title: "PhotoLibrary", style: .default) { (_) in
            self.photoLibrary()
        }
        alertVC.addAction(cameraAction)
        alertVC.addAction(photoLibraryAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func filterImage( _ image: UIImage) -> UIImage? {
        
        return UIImage()
    }
    
    private func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension PictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.originalImage = image
            self.imageVIew.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
