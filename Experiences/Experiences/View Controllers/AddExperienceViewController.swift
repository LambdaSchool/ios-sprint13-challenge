//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Christopher Devito on 5/8/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class AddExperienceViewController: UIViewController {
    
    // MARK: - Properties
    var experienceController: ExperienceController?
    var image: UIImage?
    var audio: URL?
    let context = CIContext(options: nil)
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func addImage(_ sender: Any) {
        presentImagePicker()
    }
    @IBAction func recordAudio(_ sender: Any) {
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    @IBAction func saveWithoutVideo(_ sender: Any) {
        // Mandatory to create experience
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        experienceController?.createExperience(name: title)
        
        // Optional additions to experience
        if let image = image {
            experienceController?.addImageToExperience(name: title, image: image)
        }
        if let audio = audio {
            experienceController?.addAudioToExperience(name: title, audio: audio)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews() {
        imageView.image = image
    }
    
    // MARK: - Action Methods
    func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func filterImage(originalImage: UIImage) {
        addImageButton.isHidden = true
        
        // Convert UIImage to CIImage
        guard let cgImage = originalImage.cgImage else { return }
        let ciImage = CIImage(cgImage: cgImage)
        
        // Create Filter
        let filter = CIFilter(name: "CIUnsharpMask")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(2.5, forKey: kCIInputRadiusKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)
        
        // Convert CIImage back to UIImage
        guard let outputCIImage = filter.outputImage,
            let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: originalImage.size))
            else { return }
        
        image = UIImage(cgImage: outputCGImage)
        updateViews()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddExperienceViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            filterImage(originalImage: image)
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddExperienceViewController: UINavigationControllerDelegate {
}
