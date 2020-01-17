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
    func imageVCDidPickImage(withData data: Data?)
}

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterControl: UISegmentedControl!
    @IBOutlet weak var addReplaceImageButton: UIButton!
    @IBOutlet weak var removeImageButton: UIButton!

    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

    private var imageFilterer = ImageFilterer()
    private(set) var originalImage: UIImage?

    var savedImageData: Data?

    weak var delegate: ImageVCDelegate?

    var hasImage: Bool {
        originalImage != nil
    }

    // MARK: - View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setImage(with: savedImageData)
        updateViews()
    }

    private func updateViews() {
        setFilter()
        addReplaceImageButton
            .setTitle(hasImage ? "Replace Image" : "Choose image", for: .normal)
        removeImageButton.isEnabled = hasImage
    }

    // MARK: - Actions

    @IBAction func addReplaceImageTapped(_ sender: Any) {
        addReplaceImage()
    }

    @IBAction func removeButtonTapped(_ sender: Any) {
        removeImage()
    }

    @IBAction func filterSelectionChanged(_ sender: Any) {
        setFilter()
    }

    func setFilter() {
        changeFilterSelection(
            to: ImageFilterer.FilterType.allCases[
                filterControl.selectedSegmentIndex])
        delegate?.imageVCDidPickImage(
            withData: imageView.image?.jpegData(compressionQuality: 1.0))
    }

    func removeImage() {
        originalImage = nil
        updateViews()
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

    func setImage(with data: Data?) {
        guard let data = data else { return }
        originalImage = UIImage(data: data)
        imageView.image = originalImage
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
        let width = imageView.frame.width
        let height = width * image.ratio
        originalImage = image.imageByScaling(toSize: CGSize(width: width,
                                                            height: height))
        setImageViewHeight(forAspectRatio: image.ratio)
        updateViews()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
