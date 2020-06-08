//
//  ImageViewController.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit
import Photos

protocol ImageDelegate {
    func imageButtonTapped()
}

class ImageViewController: UIViewController, UITextFieldDelegate {
    
    var postController: PostController?
    var delegate: ImageDelegate?
    var imageData: Data?
    private var blackandwhiteFilter = CIFilter(name: "CIPhotoEffectNoir")
    private var context = CIContext(options: nil)

        // MARK: IBOutlets
        @IBOutlet weak var titleTextField: UITextField!
        @IBOutlet weak var chooseImageButton: UIButton!
        @IBOutlet weak var geotagSwitch: UISwitch!
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var postButton: UIBarButtonItem!
        @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
        @IBOutlet weak var filterStackView: UIStackView!

        override func viewDidLoad() {
            super.viewDidLoad()
            postButton.isEnabled = false
            postButton.tintColor = UIColor.gray

            setImageViewHeight(with: 1.0)
            updateViews()
            titleTextField.delegate = self
        }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

        func setImageViewHeight(with aspectRatio: CGFloat) {

            imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio

            view.layoutSubviews()
        }

        func updateViews() {

            guard let imageData = imageData,
                let image = UIImage(data: imageData) else {
                    title = "New Post"
                    filterStackView.isHidden = true
                    //isFilterOptionsHidden(true)
                    return
            }

            //title = post?.title

            let ratio = image.size.height / image.size.width
            setImageViewHeight(with: ratio)

            imageView.image = image

            chooseImageButton.setTitle("", for: [])
        }

        private func scaleImage(_ image: UIImage) -> UIImage {

            var scaledSize = imageView.bounds.size
            // 1x, 2x, or 3x
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            // returning scaled image
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

        private func postImage() {
            view.endEditing(true)

            guard let title = titleTextField.text,
                !title.isEmpty else {
                presentInformationalAlertController(title: "Uh-oh", message: "Make sure that you add a caption before posting.")
                return
            }

            if geotagSwitch.isOn {
                LocationHelper.shared.getCurrentLocation { (coordinate) in
                    self.postController?.createPost(with: title, ofType: .image, location: coordinate)
                    self.delegate?.imageButtonTapped()
                    self.dismiss(animated: true) {}
                }
            } else {
                self.postController?.createPost(with: title, ofType: .image, location: nil)
                delegate?.imageButtonTapped()
                self.dismiss(animated: true, completion: nil)
            }
        }

        private func chooseImage() {
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

        private func blackandwhiteEffectImage(_ image: UIImage) -> UIImage {
            guard let cgImage = image.cgImage,
                let blackandwhiteEffect = blackandwhiteFilter else { return image }

            let ciImage = CIImage(cgImage: cgImage)

            blackandwhiteEffect.setValue(ciImage, forKey: "inputImage")

            guard let outputCIImage = blackandwhiteEffect.outputImage else { return image }

            guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return image }

            return UIImage(cgImage: outputCGImage)
        }

        private func blackandwhiteImage() {
            guard let image = imageView.image else { return }
            let scaledImage = scaleImage(image)

            imageView.image = blackandwhiteEffectImage(scaledImage)
        }

        // MARK: - IBActions
        @IBAction func chooseImageTapped(_ sender: Any) {
            chooseImage()
        }

        @IBAction func postButtonTapped(_ sender: Any) {
            postImage()
        }
    

        @IBAction func cancelButtonTapped(_ sender: Any) {
            dismiss(animated: true, completion: nil)
        }

        @IBAction func blackandwhiteSwitch(_ sender: UISwitch) {
            blackandwhiteImage()
        }
    }

    extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            chooseImageButton.setTitle("", for: [])

            picker.dismiss(animated: true, completion: nil)

            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

            imageView.image = image

            filterStackView.isHidden = false

            postButton.isEnabled = true
            postButton.tintColor = UIColor.link

            let ratio = image.size.height / image.size.width
            setImageViewHeight(with: ratio)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
