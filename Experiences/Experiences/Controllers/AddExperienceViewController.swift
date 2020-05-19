//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Joe on 5/18/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import MapKit
import AVKit

class AddExperienceViewController: UIViewController {
    
    @IBOutlet weak var newItemTitleField: UITextField!
    @IBOutlet weak var addPosterButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var xpDelegate: XPs?
    
    fileprivate var currentVC: UIViewController!
    
    //MARK: Internal Properties
    var imagePickedBlock: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    //MARK: - Actions
    
    
    @IBAction func addPosterButtonPressed(_ sender: Any) {
        presentPicker(type: .photoLibrary)
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        let photoRoll = UIImagePickerController()
        photoRoll.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        photoRoll.sourceType = .camera
        present(photoRoll, animated: true, completion: nil)
    }
    
    func save(photo: UIImage) {
        guard let image = imagePickedBlock else { return }
        imageView.image = image
        xpDelegate?.photo = image
        DispatchQueue.main.async {
            self.addPosterButton.isHidden = true
            self.imageView.isHidden = false
        }
        
        
    }
    
    func save(video: Data) {
        
    }
    
    func presentPicker(type: UIImagePickerController.SourceType) {
        let photoRoll = UIImagePickerController()
        photoRoll.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        photoRoll.sourceType = type
        present(photoRoll, animated: true, completion: nil)
    }
    
    
}


extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickedBlock = image
            save(photo: image)
        }else{
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
}
