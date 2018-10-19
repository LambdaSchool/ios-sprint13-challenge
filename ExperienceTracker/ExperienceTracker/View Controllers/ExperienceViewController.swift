//
//  ExperienceViewController.swift
//  ExperienceTracker
//
//  Created by Jonathan T. Miles on 10/19/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import UIKit
import MapKit
import Photos

class ExperienceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // AMRK: - Buttons
    
    @IBAction func addPhotoImage(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
    }
    
    @IBAction func next(_ sender: Any) {
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Properties
    
    var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var addPhotoImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
}
