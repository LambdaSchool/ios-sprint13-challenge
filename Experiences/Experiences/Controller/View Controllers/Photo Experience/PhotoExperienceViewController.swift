//
//  PhotoExperienceViewController.swift
//  Experiences
//
//  Created by Kenny on 6/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class PhotoExperienceViewController: UIViewController {
    lazy var photoController = PhotoController(delegate: self)

    @IBOutlet weak var photoFilterImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var storyTextView: UITextView!

    @IBAction func choosePhoto(_ sender: UIButton) {
        photoController.requestPermissionAndPresentImagePicker()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        storyTextView.delegate = self
    }
    


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    @IBAction func saveButton() {
        print("saved! (not implemented)")
    }


}

extension UIViewController: UITextFieldDelegate {

}

extension UIViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "Tell your story here (optional)" {
            textView.text = ""
            return true
        }
        return true
    }
}

extension PhotoExperienceViewController: PhotoUIDelegate {


}

extension PhotoExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentImagePickerController() {

        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            Alert.show(
                title: "Error",
                message: "The photo library is unavailable",
                vc: self
            )
            return
        }

        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        selectPhotoButton.setTitle("", for: [])

        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("unkown error getting image")
            return
        }
        self.photoFilterImageView.image = image
        Alert.withYesNoPrompt(
            title: "Filter This Photo?",
            message: "Would you like to add a filter?",
            vc: self
        ) { (filterChosen) in
            if filterChosen {
                //TODO: Present FilterVC
            } else {

            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
