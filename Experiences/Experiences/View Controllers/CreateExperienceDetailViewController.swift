//
//  CreateExperienceDetailViewController.swift
//  Experiences
//
//  Created by scott harris on 4/10/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit
import CoreImage.CIFilterBuiltins

class CreateExperienceDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    private var context = CIContext(options: nil)
    
    private var originalImage: UIImage? {
        didSet {
            let image = filterImage(originalImage!)
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Experience"
    }
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        addPhotoButton.isHidden = true
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: The photo library is not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
 
    }
    
    func filterImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.saturation = 0.0
        
        guard let outputCIImage = filter.outputImage else { return nil }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
        
    }
    
}

extension CreateExperienceDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
           originalImage = image
        }
        
        picker.dismiss(animated: true)
    }
}
