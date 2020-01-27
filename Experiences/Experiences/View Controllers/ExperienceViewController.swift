//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Bobby Keffury on 1/24/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ExperienceViewController: UIViewController {
    
    //MARK: - Properties
    
    //Photos
    private let context = CIContext()
    private let noirFilter = CIFilter.photoEffectNoir()
    var blackWhite: Bool = false
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage, let cgImage = originalImage.cgImage else { return }
            
            ciImage = CIImage(cgImage: cgImage)
        }
    }
    var ciImage: CIImage? {
        didSet {
            updateImage()
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var noirButton: UIButton!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    //MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImage = imageView.image
    }
    
    //MARK: - Methods
    
    // Photos
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    private func updateImage() {
        if let scaledImage = ciImage {
            noirButton.isSelected = blackWhite
            scaledImage.clampedToExtent()
            imageView.image = image(byFiltering: scaledImage)
        } else {
            imageView.image = nil
        }
    }
    private func image(byFiltering inputImage: CIImage) -> UIImage {
        if noirButton.isSelected {
            noirFilter.inputImage = inputImage
            let noirImage = (noirFilter.outputImage)!
            guard let renderedImage = context.createCGImage(noirImage, from: inputImage.extent) else { return UIImage(ciImage: inputImage)}
            return UIImage(cgImage: renderedImage)
        } else {
            return UIImage(ciImage: inputImage)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func saveTapped(_ sender: Any) {
        performSegue(withIdentifier: "saveSegue", sender: self)
    }
    
    // Photos
    @IBAction func addImageTapped(_ sender: Any) {
        presentImagePickerController()
    }
    @IBAction func blackWhiteTapped(_ sender: Any) {
        blackWhite = !blackWhite
        updateImage()
    }
    
    // Videos
    @IBAction func recordTapped(_ sender: Any) {
    }
    
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

extension ExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
        originalImage = imageView.image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
