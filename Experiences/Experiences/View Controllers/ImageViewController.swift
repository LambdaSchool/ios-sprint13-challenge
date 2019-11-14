//
//  ImageViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UINavigationControllerDelegate {
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    var media: Media?
    var delegate: ExperienceViewControllerDelegate?
    var imagePicker: UIImagePickerController!

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let media = media else { return }
        if let mediaData = media.mediaData {
            guard let imageData = UIImage(data: mediaData) else { return }
            imageView.image = imageData
        } else {
            //TODO: - Get from URL?
        }
    }
    
    @IBAction func takePhotoTapped(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let delegate = delegate,
            let media = media else {
            print("Image not found!")
            return
        }
        delegate.mediaAdded(media: media)
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
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

extension ImageViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imageView.image = selectedImage
        media = Media(mediaType: .image, url: nil, data: selectedImage.jpegData(compressionQuality: 90), date: Date())
    }
}
