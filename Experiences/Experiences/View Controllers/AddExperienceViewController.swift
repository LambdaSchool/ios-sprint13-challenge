//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Elizabeth Thomas on 9/11/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

class AddExperienceViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var chooseImageButton: UIButton!

    @IBOutlet weak var bokehSlider: UISlider!
    @IBOutlet weak var monochromeSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!


    // MARK: - Properties

    var experience: Experience?
    var experienceController: ExperienceController?
    var imageData: Data?
    var audioURL: URL?
    let locationManager = CLLocationManager.shared
    var currentLocation: CLLocation!
    private let context = CIContext()

    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else {
                scaledImage = nil
                return
            }

            var scaledSize = imageView.bounds.size
            let scale = imageView.contentScaleFactor

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

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()

        originalImage = imageView.image

        locationManager.delegate = self

    }

    func updateViews() {

        guard let imageData = imageData,
            let image = UIImage(data: imageData) else { return }

        imageView.image = image

        chooseImageButton.setTitle("", for: [])
    }

    // MARK: - Functions

    func updateImage() {
        if let scaledImage = scaledImage {
            imageView.image = image(byFiltering: scaledImage)
        } else {
            imageView.image = nil
        }
    }

    private func image(byFiltering image: CIImage) -> UIImage? {

        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = image
        blurFilter.radius = bokehSlider.value

        let monochromeFilter = CIFilter.colorMonochrome()
        monochromeFilter.inputImage = blurFilter.outputImage
        monochromeFilter.intensity = monochromeSlider.value

        let saturationFilter = CIFilter.sepiaTone()
        saturationFilter.inputImage = monochromeFilter.outputImage
        saturationFilter.intensity = saturationSlider.value

        guard let outputImage = saturationFilter.outputImage else { return nil }

        guard let renderedCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }

        return UIImage(cgImage: renderedCGImage)
    }

    private func presentImagePickerController() {

        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)

    }

    // MARK: - IBActions

    @IBAction func chooseImage(_ sender: Any) {

        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:

            PHPhotoLibrary.requestAuthorization { (status) in

                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                self.presentImagePickerController()
            }

        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
        default:
            break
        }
        presentImagePickerController()
    }

    @IBAction func bokehSliderUpdated(_ sender: Any) {
        updateImage()
    }

    @IBAction func monochromeSliderUpdated(_ sender: Any) {
        updateImage()
    }

    @IBAction func saturationSliderUpdated(_ sender: Any) {
        updateImage()
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        view.endEditing(true)

        guard let image = imageView.image,
            let title = titleTextField.text, title != "" else {
                presentInformationalAlertController(title: "Uh-oh", message: "Please make sure you add a photo and a caption before posting!")
                return
        }

        guard let location = locationManager.location?.coordinate else {
            return
        }

        if audioURL != nil {
            experienceController?.createExperience(with: title, image: image, audioURL: audioURL, location: location)
        } else {
            experienceController?.createExperience(with: title, image: image, location: location)
        }

        navigationController?.popToRootViewController(animated: true)
    }

}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        chooseImageButton.setTitle("", for: [])

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
