//
//  ViewController.swift
//  Experience
//
//  Created by Sammy Alvarado on 11/7/20.
//

import UIKit
import Photos


class PhotoAndAudioViewController: UIViewController {
    
    // MARK: PROPERTIES
    
    let imagePicker = UIImagePickerController()
    
    // MARK: OUTLETS
    
    @IBOutlet var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: FUNCTIONS
    private func posterSelector() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The Photo Libaray was not made available.")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
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
    
}

