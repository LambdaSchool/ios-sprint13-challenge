//
//  ViewController.swift
//  Experience
//
//  Created by Sammy Alvarado on 11/7/20.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins


class PhotoAndAudioViewController: UIViewController {
    
    // MARK: PROPERTIES
    
    let imagePicker = UIImagePickerController()
    
//    var posterImage: UIImage? {
//        didSet {
//            guard let posterImage = posterImage else {
//                scaledImage = nil
//                return
//            }
//
//            var scaledSize = posterImageView.bounds.size
//            let scale = posterImageView.contentScaleFactor
//
//            scaledSize.width *= scale
//            scaledSize.height *= scale
//
//            guard let scaledUIImage = posterImage.imageByScaling(toSize: scaledSize) else {
//                scaledImage = nil
//                return
//            }
//
//            scaledImage = CIImage(image: scaledUIImage)
//        }
//    }
//
//    var scaledImage: CIImage? {
//        didSet {
//            updateImageView()
//        }
//    }
    
    // MARK: OUTLETS
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var addPosterImageButtonSelector: UIButton!
    
    
    // MARK: FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        posterImage = posterImageView.image
        imagePicker.delegate = self
    }
    

    
//    private func updateImageView() {
//        var scaledImages = scaledImage
////        {
////            posterImageView.image = image(byFiltering: scaledImage)
////        } else {
////            posterImageView.image = nil
////        }
//    }
    
    private func posterSelector() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The Photo Libaray was not made available.")
            return
        }
        
        if imagePicker.sourceType == .photoLibrary {
            addPosterImageButtonSelector.isHidden = true
        } else {
            addPosterImageButtonSelector.isHidden = false
        }
            
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func camaraSelector() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("The Camera was not made available.")
            return
        }
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: ACTIONS
    @IBAction func addPosterImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.posterSelector()
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.camaraSelector()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

    // MARK: EXTENSIONS
extension PhotoAndAudioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            posterImageView.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            posterImageView.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

