//
//  ImageViewController.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Photos

protocol ImageViewControllerDelegate {
    func imagePostButtonWasTapped()
}

class ImageViewController: UIViewController {

    var entryController: EntryController?
    var imageData: Data?
    var delegate: ImageViewControllerDelegate?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var geotagSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        postButton.isEnabled = false
        postButton.tintColor = UIColor.gray

        setImageViewHeight(with: 1.0)
        updateViews()

    }

    func setImageViewHeight(with aspectRatio: CGFloat) {

        imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio

        view.layoutSubviews()
    }

    func updateViews() {

        guard let imageData = imageData,
            let image = UIImage(data: imageData) else {
                title = "New Post"
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
                self.entryController?.createPost(with: title, ofType: .image, location: coordinate)
                self.delegate?.imagePostButtonWasTapped()
                self.dismiss(animated: true) {}
            }
        } else {
            self.entryController?.createPost(with: title, ofType: .image, location: nil)
            delegate?.imagePostButtonWasTapped()
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

}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        chooseImageButton.setTitle("", for: [])

        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        imageView.image = image

//      isFilterOptionsHidden(false)

        postButton.isEnabled = true
        postButton.tintColor = UIColor.link

        let ratio = image.size.height / image.size.width
        setImageViewHeight(with: ratio)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
