//
//  PostViewController.swift
//  SprintChallenge
//
//  Created by Elizabeth Wingate on 4/10/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController {
    var experienceController: ExperienceController?
    
     var postLocation: CLLocationCoordinate2D?
    
    @IBOutlet var titleTextField: UITextField!
     @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(back))
    }
    
    var currentImage: UIImage? {
        didSet {
            print("Prepare for record")
            //prepareForRecord()
        }
    }
    
    @IBAction func addImageButtonPressed(_ sender: Any) {
      guard let title = titleTextField.text, !title.isEmpty else {
            NSLog("title is empty")
            return
        }
        addPhotoRequest()
}

     @IBAction func recordButtonPressed(_ sender: Any) {
         print("recordButtonPressed")
     }
    
    @objc func back() {
         dismiss(animated: true, completion: nil)
     }

    func addPhotoRequest() {
         imageView.image = nil
         guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
             fatalError("AddPhoto error")
         }

         let imagePicker = UIImagePickerController()
         imagePicker.sourceType = .photoLibrary

         imagePicker.delegate = self
         present(imagePicker, animated: true)
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

extension PostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       picker.dismiss(animated: true)
   }

   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       picker.dismiss(animated: true) {
           if let image = info[.originalImage] as? UIImage {
            self.currentImage = image.myCIColorControlsFilter(image: image)
           }
       }
   }
}
