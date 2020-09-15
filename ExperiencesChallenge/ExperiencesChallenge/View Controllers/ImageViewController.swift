//
//  ImageViewController.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//


import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

protocol ImageViewControllerDelegate {
    func saveImageButtonTapped()
}

class ImageViewController: UIViewController {

    var experienceController: ExperienceController?
    var imageData: Data?
    var delegate: ImageViewControllerDelegate?

    private var chromeFilter = CIFilter(name: "CIPhotoEffectChrome")
    let context = CIContext(options: nil)

    // MARK: IBOutlets

    @IBOutlet weak var saveImageButton: UIBarButtonItem!
    @IBOutlet weak var filterStackview: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var addLocationSwitch: UISwitch!
    @IBOutlet weak var chromeSwitch: UISwitch!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        saveImageButton.isEnabled = false
        saveImageButton.tintColor = UIColor.gray

        setImageViewHeight(with: 1.0)
        updateViews()

    }

    func setImageViewHeight(with aspectRatio: CGFloat) {

        imageHeight.constant = imageView.frame.size.width * aspectRatio
        view.layoutSubviews()
    }

    func updateViews() {

        guard let imageData = imageData,
            let image = UIImage(data: imageData) else {
                title = "New Image"
                filterStackview.isHidden = true
                return
        }

        let ratio = image.size.height / image.size.width
        setImageViewHeight(with: ratio)

        imageView.image = image

        chooseImageButton.setTitle("", for: [])
    }

    private func scaleImage(_ image: UIImage) -> UIImage {

        var scaledSize = imageView.bounds.size

        let scale = UIScreen.main.scale
        scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)

        return image.imageByScaling(toSize: scaledSize) ?? UIImage()
    }

    private func presentImagePickerController() {

        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }

        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    private func addImage() {
        view.endEditing(true)

        guard let title = titleTextField.text,
            !title.isEmpty else {
                presentInformationalAlertController(title: "Uh-oh", message: "Make sure that you add a caption before posting.")
                return
        }

        if addLocationSwitch.isOn {
            LocationHelper.shared.getCurrentLocation { (coordinate) in
                self.experienceController?.createPost(with: title, ofType: .image, location: coordinate)
                self.delegate?.saveImageButtonTapped()
                self.dismiss(animated: true) {}
            }
        } else {
            self.experienceController?.createPost(with: title, ofType: .image, location: nil)
            delegate?.saveImageButtonTapped()
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func selectImage() {
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

        @unknown default:
            fatalError()
        }
        presentImagePickerController()
    }

    private func chromeEffectImage(_ image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage,
            let chromeEffect = chromeFilter
            else { return image}
        let ciImage = CIImage(cgImage: cgImage)

        chromeEffect.setValue(ciImage, forKey: "inputImage")
        guard let outputCIImage = chromeEffect.outputImage else { return image }

        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return image }

        return UIImage(cgImage: outputCGImage)
    }

    private func chromeImage() {
        guard let image = imageView.image else { return }
        let scaledImage = scaleImage(image)

        imageView.image = chromeEffectImage(scaledImage)
    }

    // MARK: - IBActions

    @IBAction func saveImageButtonTapped(_ sender: Any) {
        addImage()
    }

    @IBAction func selectImageButtonTapped(_ sender: Any) {
        selectImage()
    }

    @IBAction func chromeSwitchChanged(_ sender: Any) {
        chromeImage()
    }


    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        chooseImageButton.setTitle("", for: [])

        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        imageView.image = image

        filterStackview.isHidden = false

        saveImageButton.isEnabled = true
        saveImageButton.tintColor = UIColor.link

        let ratio = image.size.height / image.size.width
        setImageViewHeight(with: ratio)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
