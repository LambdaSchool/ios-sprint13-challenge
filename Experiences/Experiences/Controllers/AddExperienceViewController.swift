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
        xpDelegate?.photo = photo
        DispatchQueue.main.async {
            self.imageView.image = photo
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


