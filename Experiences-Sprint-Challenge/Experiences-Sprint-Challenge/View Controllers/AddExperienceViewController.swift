//
//  AddExperienceViewController.swift
//  Experiences-Sprint-Challenge
//
//  Created by Matthew Martindale on 7/19/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class AddExperienceViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    
    // MARK: - Properties
    private let context = CIContext()
    private let colorControlFilter = CIFilter.colorControls()
    
    // MARK: - View Controller Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 50)
        
        // setup photoImage
        let photoImage = UIImage(systemName: "photo", withConfiguration: configuration)
        photoButton.setImage(photoImage, for: .normal)
        
        // setup micImage
        let micImage = UIImage(systemName: "mic.fill", withConfiguration: configuration)
        micButton.setImage(micImage, for: .normal)
    }

    // MARK: - Methods
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
    
    private func saturateImage(_ inputImage: CIImage) -> UIImage? {
        colorControlFilter.inputImage = inputImage
        colorControlFilter.saturation = 2.0
        
        guard let outputImage = colorControlFilter.outputImage else { return nil}
        
        return UIImage(ciImage: outputImage)
    }
    
    // MARK: - IBActions
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        presentImagePickerController()
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
    }
    
}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let uiImage = info[.originalImage] as? UIImage else { return }
        guard let coreImage = CIImage(image: uiImage) else { return }
        guard let image = saturateImage(coreImage) else { return }
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
