//
//  EntryViewController.swift
//  Experiences
//
//  Created by Lotanna Igwe-Odunze on 2/22/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Properties
    let photoPicker = UIImagePickerController()
    
    //Overrides
    override func viewDidLoad() {
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        photoPicker.allowsEditing = true
    }
    
    //Outlets
    @IBOutlet weak var entryImage: UIImageView!
    
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBOutlet weak var titleField: UITextField!
    
    //Actions
    @IBAction func choosePhoto(_ sender: UIButton) {
        //Show the Photo Library so the user can pick a photo
        present(photoPicker, animated: true, completion: nil)
    }
    
    @IBAction func recordVideo(_ sender: UIButton) {
        
    }
    
    @IBAction func saveEntry(_ sender: UIBarButtonItem) {
        
    }
    
    //Delegate Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //What happens once the user has selected an image. Lets you adjust the image.
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] {
            entryImage.image = selectedImage as? UIImage //Assign to entry image
        }
        
        dismiss(animated: true, completion: nil) //Dismiss the picker
    }
}
