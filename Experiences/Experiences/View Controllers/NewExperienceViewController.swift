//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class NewExperienceViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Properties
    var experienceController: ExperienceController!
    
    private let context = CIContext(options: nil)
    private var originalImage: UIImage? {
        didSet { updateImageView() }
    }

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - UI Actions
    
    @IBAction func addPhoto(_ sender: Any) {
        PhotoLibraryHelper.shared.checkAuthorizationStatus { (alertController) in
            if let alertController = alertController {
                self.present(alertController, animated: true)
            } else {
                self.presentImagePickerController()
            }
        }
    }
    
    @IBAction func playAudio(_ sender: Any) {
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - UI Image Picker Controller Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        addPhotoButton.setTitle("", for: .normal)
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        originalImage = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    // MARK: - Private Utility Methods
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let errorAlert = UIAlertController.informationalAlertController(message: "The photo library is unavailable")
            present(errorAlert, animated: true)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func updateImageView() {
        guard let image = originalImage else { return }
        
        imageView.image = reduceAndFilter(image)
    }
    
    private func reduceAndFilter(_ image: UIImage?, longEdge resolution: Int = 1000) -> UIImage? {
        guard var inputImage: CIImage = image?.getCIImage() else { return image }
        
        let scale = CGFloat(resolution) / max(inputImage.extent.size.width, inputImage.extent.size.height)
        if scale < 1 {
            let scaleFilter = CIFilter(name: "CILanczosScaleTransform")!
            scaleFilter.setValue(inputImage, forKey: kCIInputImageKey)
            scaleFilter.setValue(scale, forKey: kCIInputScaleKey)
            if let outputImage = scaleFilter.outputImage { inputImage = outputImage}
        }
        
        let monochromeFilter = CIFilter(name: "CIColorMonochrome")!
        let color = CIColor(red: 0.5, green: 0.5, blue: 0.5)
        monochromeFilter.setValue(inputImage, forKey: kCIInputImageKey)
        monochromeFilter.setValue(color, forKey: kCIInputColorKey)
        monochromeFilter.setValue(1.0, forKey: kCIInputIntensityKey)
        
        guard let outputImage = monochromeFilter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        
        return UIImage(cgImage: cgImage)
    }
}
