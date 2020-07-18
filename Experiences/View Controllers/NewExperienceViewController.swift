//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Chad Parker on 7/17/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import MapKit

protocol NewExperienceDelegate {
    func newExperienceSaved(_ experience: Experience)
}

class NewExperienceViewController: UIViewController {

    // MARK: - Properties

    var delegate: NewExperienceDelegate!
    var currentLocation: CLLocationCoordinate2D!

    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var imageView: UIImageView!


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Actions

    @IBAction func addPosterImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }

        let newExperience = Experience(title: title, image: imageView.image, location: currentLocation)
        delegate.newExperienceSaved(newExperience)

        dismiss(animated: true, completion: nil)
    }
}


// MARK: - ImagePicker Delegate

extension NewExperienceViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { fatalError("No image from picker") }
        
        imageView.image = ImageProcessor.desaturate(image)
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
