//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Josh Kocsis on 9/11/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//


import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import AVFoundation

class NewExperienceViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var newExperienceImageView: UIImageView!
    @IBOutlet weak var audioRecordingButton: UIButton!

    var experience: Experience?

        var originalImage: UIImage? {
            didSet {
                guard let originalImage = originalImage else {
                    scaledImage = nil
                    return
                }

                var scaledSize = newExperienceImageView.bounds.size
                let scale = newExperienceImageView.contentScaleFactor

                scaledSize.width *= scale
                scaledSize.height *= scale

                guard let scaledUIImage = originalImage.imageByScaling(toSize: scaledSize) else {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = newExperienceImageView.image
    }

    private func showImagePickerControllerActionSheet() {
        let alert = UIAlertController()

        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.presentImagePickerController(sourceType: .photoLibrary)
        }

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePickerController(sourceType: .camera)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)

    }

    private func presentImagePickerController(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available.")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }

    private func image(byFiltering inputImage: CIImage) -> UIImage? {
        guard let currentCGImage = inputImage.cgImage else { return nil }
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")

        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return nil }

        let context = CIContext()

        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)!
        let processedImage = UIImage(cgImage: cgimg)

        return processedImage
    }

    func updateImage() {
        if let scaledImage = scaledImage {
            newExperienceImageView.image = image(byFiltering: scaledImage)
        } else {
            newExperienceImageView.image = nil
        }
    }

    @IBAction func addImageTapped(_ sender: UIButton) {
        showImagePickerControllerActionSheet()
    }

    @IBAction func audioRecordingTapped(_ sender: UIButton) {

    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {

    }

}


extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
