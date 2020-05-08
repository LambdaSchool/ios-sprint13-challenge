//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Christopher Devito on 5/8/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit

class AddExperienceViewController: UIViewController {
    
    // MARK: - Properties
    var experienceController: ExperienceController?
    var image: UIImage?
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func addImage(_ sender: Any) {
        presentImagePicker()
    }
    @IBAction func recordAudio(_ sender: Any) {
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action Methods
    func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddExperienceViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.image = image
            self.addImageButton.isHidden = true
            self.imageView.isHidden = false
            self.imageView.image = image
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddExperienceViewController: UINavigationControllerDelegate {
}
