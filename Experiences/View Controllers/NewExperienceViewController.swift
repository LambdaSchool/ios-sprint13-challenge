//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Chad Parker on 7/17/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

class NewExperienceViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imageView: UIImageView!


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


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}


// MARK: - ImagePicker

extension NewExperienceViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
