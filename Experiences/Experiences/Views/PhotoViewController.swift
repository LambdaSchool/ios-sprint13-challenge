//
//  PhotoViewController.swift
//  Experiences
//
//  Created by Kevin Stewart on 7/17/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

protocol AddExperienceDelegate {
    func experienceWasAdded(experience: Experience)
}

class PhotoViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageSlider: UISlider!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var choosePhotoButton: UIBarButtonItem!
    @IBOutlet var titleTextField: UITextField!
    
    //MARK: - Properties and computed properties
    var experienceController: ExperienceController?
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    var imageURL: URL?
    
    var origionalImage: UIImage? {
        didSet {
            guard let origionalImage = origionalImage else {
                scaledImage = nil
                return
            }
            
            let scale = UIScreen.main.scale
            
            var scaledSize = imageView.bounds.size
            scaledSize = CGSize(width: scaledSize.width * scale,
                                height: scaledSize.height * scale)
            guard let scaledUIImage = origionalImage.imageByScaling(toSize: scaledSize) else {
                scaledImage = nil
                return
            }
            
            scaledImage = CIImage(image: scaledUIImage)
        }
    }
    
    var scaledImage: CIImage? {
        didSet {
            updateImage()
        }
    }
    
    var delegate: AddExperienceDelegate?
    private let context = CIContext()
    private let sepiaToneFilter = CIFilter.sepiaTone()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origionalImage = imageView.image
    }
    
    //MARK: - Methods
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("jpeg")
        
        return file
    }
    
    private func updateViews() {
        titleTextField.text = experience?.title
    }
    
    private func image(byFiltering inputImage: CIImage) -> UIImage? {
        sepiaToneFilter.inputImage = inputImage
        sepiaToneFilter.intensity = imageSlider.value
        
        guard let outputImage = sepiaToneFilter.outputImage else { return nil }
        guard let renderCGImage = context.createCGImage(outputImage, from: inputImage.extent) else { return nil }
        
        return UIImage(cgImage: renderCGImage)
    }
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            imageView.image = image(byFiltering: scaledImage)
        } else {
            imageView.image = nil
        }
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Could not access photo library.")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    // MARK: Actions
    
    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func savePhotoButtonPressed(_ sender: UIBarButtonItem) {
        guard let originalImage = origionalImage?.flattened,
            let ciImage = CIImage(image: originalImage) else { return }
        
        guard let processedImage = image(byFiltering: ciImage) else { return }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: processedImage)
        }) { (success, error) in
            if let error = error {
                print("Error saving photo: \(error)")
                return
            } else {
                DispatchQueue.main.async {
                    self.presentSuccessfulSaveAlert()
                }
            }
        }
        guard let newPhotoTitle = titleTextField.text,
            !newPhotoTitle.isEmpty else { return }
        let imageURL = createNewRecordingURL()
        delegate?.experienceWasAdded(experience: Experience(name: newPhotoTitle,
                                                            url: imageURL))
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func presentSuccessfulSaveAlert() {
        let alert = UIAlertController(title: "Photo Saved!", message: "The photo has been saved to your Photo Library!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Slider events
    
    @IBAction func brightnessChanged(_ sender: UISlider) {
        updateImage()
    }
}

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            origionalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            origionalImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
