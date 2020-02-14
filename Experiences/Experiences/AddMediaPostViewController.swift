//
//  AddMediaPostViewController.swift
//  Experiences
//
//  Created by Alex Shillingford on 2/14/20.
//  Copyright © 2020 shillwil. All rights reserved.
//

import UIKit
import CoreImage
import Photos
import AVFoundation

class AddMediaPostViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var mediaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    
    var experiences: [ExperienceEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func showImagePicker() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func cancelPost(_ sender: UIButton) {
        
    }
    
    @IBAction func post(_ sender: UIButton) {
        switch mediaSegmentedControl.selectedSegmentIndex {
        case 0:
            if let title = titleTextField.text,
                !title.isEmpty,
                let description = descriptionTextView.text,
                let image = imageView.image {
                let entry = ExperienceEntry(title: title, description: description, photo: image, movie: nil, audio: nil, id: UUID())
                experiences.append(entry)
                print(experiences.description)
                self.dismiss(animated: true)
            }
        case 1:
            print("movie")
        case 2:
            print("recording")
        default:
            print("default")
        }
        
        
    }
    
    @IBAction func addMediaButtonTapped(_ sender: UIButton) {
        switch mediaSegmentedControl.selectedSegmentIndex {
        case 0:
            showImagePicker()
        case 1:
            print(1)
        case 2:
            print(2)
        default:
            print("unknown default")
        }
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

extension AddMediaPostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddMediaPostViewController: UINavigationControllerDelegate {
    
}
