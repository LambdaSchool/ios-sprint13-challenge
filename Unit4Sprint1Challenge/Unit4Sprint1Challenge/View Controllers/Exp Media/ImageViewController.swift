//
//  ImageViewController.swift
//  Unit4Sprint1Challenge
//
//  Created by Jon Bash on 2020-01-17.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import UIKit
import Photos

protocol ImageVCDelegate: AnyObject {
    func imageVCDidPickImage(withData data: Data)
}

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterControl: UISegmentedControl!
    @IBOutlet weak var addReplaceImageButton: UIButton!

    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

    private var imageFilterer = ImageFilterer()
    private(set) var originalImage: UIImage?

    weak var delegate: ImageVCDelegate?

    var hasImage: Bool {
        originalImage != nil
    }

    // MARK: - View Lifecycle

    private func updateViews() {

    }

    // MARK: - Actions

    @IBAction func addReplaceImageTapped(_ sender: Any) {
        addReplaceImage()
    }

    @IBAction func filterSelectionChanged(_ sender: Any) {
        setFilter()
    }

    func setFilter() {
        changeFilterSelection(
            to: ImageFilterer.FilterType.allCases[
                filterControl.selectedSegmentIndex])
    }

    func addReplaceImage() {
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
                DispatchQueue.main.async {
                    self.presentImagePickerController()
                }
            }
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
        @unknown default:
            break
        }
        presentImagePickerController()
    }

    func changeFilterSelection(to filterType: ImageFilterer.FilterType) {
        if let image = originalImage {
            imageView.image = imageFilterer
                .filterImage(image,
                             withType: filterType)
        }
    }

    // MARK: - Helpers

    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(
                title: "Error",
                message: "The photo library is unavailable")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        self.present(imagePicker, animated: true, completion: nil)
    }

    private func setImageViewHeight(forAspectRatio aspectRatio: CGFloat) {
        imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio

        view.layoutSubviews()
    }
}

// MARK: - Image Picker Delegate

extension ImageViewController: UINavigationControllerDelegate {}

extension ImageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        addReplaceImageButton.setTitle("Replace Image", for: .normal)

        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage
            else { return }
        originalImage = image

        setImageViewHeight(forAspectRatio: image.ratio)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
