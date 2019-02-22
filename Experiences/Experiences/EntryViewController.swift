//
//  EntryViewController.swift
//  Experiences
//
//  Created by Lotanna Igwe-Odunze on 2/22/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class EntryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Properties
    let mediaPicker = UIImagePickerController()
    
    //Overrides
    override func viewDidLoad() {
        mediaPicker.delegate = self
        
    }
    
    //Outlets
    @IBOutlet weak var entryImage: UIImageView!
    
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBOutlet weak var titleField: UITextField!
    
    //Actions
    @IBAction func choosePhoto(_ sender: UIButton) {
        mediaPicker.sourceType = .photoLibrary
        mediaPicker.allowsEditing = false
        //Show the Photo Library so the user can pick a photo
        present(mediaPicker, animated: true, completion: nil)
    }
    
    @IBAction func recordVideo(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) { //Check camera access
        mediaPicker.sourceType = .camera
        mediaPicker.allowsEditing = false
        mediaPicker.mediaTypes = [kUTTypeMovie as String]
        present(mediaPicker, animated: true, completion: nil)
        } else { print("Camera unavailable") }

    }
    
    @IBAction func saveEntry(_ sender: UIBarButtonItem) {
        
    }
    
    //Delegate Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //What happens once the user has selected an image. Lets you adjust the image.
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] {
            entryImage.image = selectedImage as? UIImage //Assign to entry image
        }
        
        dismiss(animated: true, completion: nil) //Dismiss the picker
    }
}
