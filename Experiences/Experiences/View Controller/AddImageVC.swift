//
//  AddImageVC.swift
//  Experiences
//
//  Created by Norlan Tibanear on 1/22/21.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

protocol addImageDelegate: AnyObject {
    func addImage(image: UIImage)
}

class AddImageVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var photo: UIImageView!
    
    
    // Properties
    var image: UIImage? = nil
    
    weak var delegate: addImageDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageView()
    }
    
    @IBAction func saveImage(_ sender: Any) {
        guard let image = photo.image else { return }
        delegate?.addImage(image: image)
        
        dismiss(animated: true, completion: nil)
    }
    
    func setupImageView() {
        photo.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        photo.addGestureRecognizer(tapGesture)
    }

    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }//
    

}// CLASS


extension AddImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            photo.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            image = imageOriginal
            photo.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }


}//
