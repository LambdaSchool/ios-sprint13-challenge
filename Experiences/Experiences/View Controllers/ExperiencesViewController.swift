//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Jesse Ruiz on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Photos

class ExperiencesViewController: UIViewController {
    
    // MARK: - Properties
    var originalImage: UIImage?
    let context = CIContext(options: nil)
    var imageData: Data?
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var addFilterButton: UIButton!
    @IBOutlet weak var addAudioButton: UIButton!
    @IBOutlet weak var addVideoButton: UIButton!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        guard imageView.image == nil else { return }
        addFilterButton.isHidden = true
        addAudioButton.isHidden = true
        addVideoButton.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func addImage(_ sender: UIButton) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                self.presentImagePickerController()
            }
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
        default:
            break
        }
        presentImagePickerController()
    }
    
    
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: completion)
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    enum ImageFilter: String {
        case fade = "CIPhotoEffectFade"
        case chrome = "CIPhotoEffectChrome"
        case instant = "CIPhotoEffectInstant"
        case noir = "CIPhotoEffectNoir"
        case none
        
        static var allFilters: [ImageFilter] = [.fade]
    }
    
    @IBAction func addFilter(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a filter", message: nil, preferredStyle: .actionSheet)
        
        let fadeAction = UIAlertAction(title: "Fade", style: .default) { (_) in
            self.filterImage(withFilter: .fade)
        }
        let chromeAction = UIAlertAction(title: "Chrome", style: .default) { (_) in
            self.filterImage(withFilter: .chrome)
        }
        let instantAction = UIAlertAction(title: "Instant", style: .default) { (_) in
            self.filterImage(withFilter: .instant)
        }
        let noirAction = UIAlertAction(title: "Noir", style: .default) { (_) in
            self.filterImage(withFilter: .noir)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(fadeAction)
        alert.addAction(chromeAction)
        alert.addAction(instantAction)
        alert.addAction(noirAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func filterImage(withFilter filter: ImageFilter, parameters: [String: CGFloat] = [:]) {
        
        guard let image = originalImage else { return }
        
        if let imageFilter = CIFilter(name: filter.rawValue) {
            
            let startImage = CIImage(image: image)
            imageFilter.setValue(startImage, forKey: kCIInputImageKey)
            
            for (key, value) in parameters {
                imageFilter.setValue(value, forKey: key)
            }
            
            guard let outputImage = imageFilter.outputImage,
                let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
            
            let image = UIImage(cgImage: cgImage)
            
            imageView.image = image
        }
    }
    
    @IBAction func saveExperience(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.1),
            let title = titleTextField.text, title != "" else {
                presentInformationalAlertController(title: "Uh-Oh!", message: "Make sure you add a photo and a title before saving.")
                return
        }
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
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

extension ExperiencesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        originalImage = image
        
        addFilterButton.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
