//
//  PhotoViewController.swift
//  Experiences
//
//  Created by Percy Ngan on 1/17/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit
import Photos

class PhotoViewController: UIViewController {

	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK: - Properties
	var originalImage: UIImage?

	var scaledImage: UIImage? {
		didSet {

		}
	}

	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK: - Outlets

	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var addPosterImageButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var imageHeightContraint: NSLayoutConstraint!



	override func viewDidLoad() {
		super.viewDidLoad()

		setImageViewHeight(with: 1.0)
		updateViews()
	}

	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK: Helper Methods

	func updateViews() {

		guard imageView.image == nil else { return }
	}

	private func presentImagePickerController() {
		guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
			presentInformationalAlert(title: "Error", message: "The photo library is unavailable")
			return }

		let imagePicker = UIImagePickerController()
		imagePicker.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
		imagePicker.sourceType = .photoLibrary

		present(imagePicker, animated: true, completion: nil)
	}

	func setImageViewHeight(with aspectRatio: CGFloat) {

		imageHeightContraint.constant = imageView.frame.size.width * aspectRatio

		view.layoutSubviews()
	}



	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK:- - Actions

	@IBAction func addPosterImageButton(_ sender: Any) {

		print("Button pressed")

		let authorizationStatus = PHPhotoLibrary.authorizationStatus()

		switch authorizationStatus {
		case .authorized:
			presentImagePickerController()
		case .notDetermined:

			PHPhotoLibrary.requestAuthorization { (status) in

				guard status == .authorized else {
					NSLog("User did not authorize access to the photo library")
					self.presentInformationalAlert(title: "Error", message: "To access the photo library, you must grant this application permission")
					return
				}
				self.presentImagePickerController()
			}
		case .denied:
			self.presentInformationalAlert(title: "Error", message: "To access the photo library, you must grant this application permission")
		case .restricted:
			self.presentInformationalAlert(title: "Error", message: "Unable to access the photo library because this app doesn't have permission")
		default:
			break
		}
		presentImagePickerController()
	}

	@IBAction func recordButton(_ sender: Any) {
	}

}



extension PhotoViewController: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

		addPosterImageButton.setTitle("", for: [])

		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

		imageView.image = image
		originalImage = image

		setImageViewHeight(with: image.ratio)

	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
}

