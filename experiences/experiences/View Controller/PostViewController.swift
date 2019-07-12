//
//  PostViewController.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit
import MapKit


class PostViewController: UIViewController {
	var experienceController: ExperienceController?
	
	@IBOutlet var recordButton: UIButton!
	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var imageView: UIImageView!
	
	var currentImage: UIImage? {
		didSet {
			print("Prepare for record")
			prepareForRecord()
		}
	}
	
	func prepareForRecord() {
		imageView.image = currentImage!
		recordButton.isEnabled = true
		recordButton.backgroundColor = .red
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		recordButton.isEnabled = false
	}
	
	@IBAction func back(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	

	@IBAction func addPosterButtonPressed(_ sender: Any) {
		guard let title = titleTextField.text, !title.isEmpty else {
			NSLog("title is empty")
			return
		}
		
		addPhotoRequest()
	}
	
	@IBAction func recordButtonPressed(_ sender: Any) {
		guard currentImage != nil else {
			NSLog("currentImage is empty")
			return
		}
		
		print("recordButtonPressed")
		
	}
	
	func addPhotoRequest() {
		imageView.image = nil
		
		guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
			fatalError("AddPhoto error")
		}
		
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = .photoLibrary
		
		imagePicker.delegate = self
		present(imagePicker, animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "CameraViewController" {
			guard let vc = segue.destination as? CameraViewController,
				let fileTitle = titleTextField.text, !fileTitle.isEmpty else {
				NSLog("title is empty")
				return
			}
			
			vc.fileTitle = fileTitle
			vc.experienceController = experienceController
		}
	}
	
}

extension PostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true) {
			if let image = info[.originalImage] as? UIImage {
				self.currentImage = image.myCIColorControlsFilter()
			}
		}
	}
}
