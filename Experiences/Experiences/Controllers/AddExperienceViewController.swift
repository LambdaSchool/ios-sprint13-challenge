//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Joe on 5/18/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class AddExperienceViewController: UIViewController {

    @IBOutlet weak var newItemTitleField: UITextField!
    @IBOutlet weak var addPosterButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let xpDelegate: [XPs] = []
        
    fileprivate var currentVC: UIViewController!
        
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    //MARK: - Actions
    
    
    @IBAction func addPosterButtonPressed(_ sender: Any) {
        let photoRoll = UIImagePickerController()
        photoRoll.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        photoRoll.sourceType = .photoLibrary
        present(photoRoll, animated: true, completion: nil)
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        let photoRoll = UIImagePickerController()
        photoRoll.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        photoRoll.sourceType = .camera
        present(photoRoll, animated: true, completion: nil)
    }
    
    func save(photo: UIImage) {
        
    }
    
    func save(video: Data) {
        
    }
    

}

extension AddExperienceViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
        }else{
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
}
