//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Mitchell Budge on 7/12/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit
import Photos

class NewExperienceViewController: UIViewController {

    // MARK: - Properties
    
    var originalImage: UIImage? {
        didSet {
            
        }
    }
    private let filter = CIFilter(name: "CIPhotoEffectNoir")
    private let context = CIContext(options: nil)
    lazy private var recorder = Recorder()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addPosterImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Methods
    
    func updateImage() {
        if let originalImage = originalImage {
            imageView.image = image(byFiltering: originalImage)
            addPosterImageButton.isHidden = true
        } else {
            imageView.image = nil
        }
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        guard let cgImage = originalImage?.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        filter?.setValue(ciImage, forKey: "inputImage")
        guard let outputCIImage = filter?.outputImage else { return image }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        return UIImage(cgImage: outputCGImage)
        
    }
    
    private func updateViews() {
        recordButton.setTitle(recorder.isRecording ? "Stop Recording" : "Record", for: .normal)
    }
    
    @IBAction func addPosterImageButtonPressed(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is unavailable")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
        guard let originalImage = originalImage else { return }
        let processedImage = image(byFiltering: originalImage)
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: processedImage)
            }, completionHandler: { (success, error) in
                if let error = error {
                    NSLog("Error saving photo: \(error)")
                    return
                }
                NSLog("Saved photo!")
            })
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        recorder.toggleRecording()
    }
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, RecorderDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func recorderDidChangeState(recorder: Recorder) {
        updateViews()
    }

}
