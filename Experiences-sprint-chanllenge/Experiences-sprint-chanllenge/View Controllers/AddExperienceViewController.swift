//
//  AddExperienceViewController.swift
//  Experiences-sprint-chanllenge
//
//  Created by Gi Pyo Kim on 12/6/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit
import Photos

class AddExperienceViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    
    private let context = CIContext(options: nil)
    var experienceController: ExperienceController?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func updateViews() {
        guard let image = image else { return }
        
        imageView.image = filterImage(image)
    }
    
    private func filterImage(_ image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image}
        
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIPhotoEffectInstant")!
        filter.setValue(ciImage, forKey: "inputImage")
        
        guard let outputCIImage = filter.outputImage else { return image }
        
        let bounds = CGRect(origin: CGPoint.zero, size: image.size)
        guard let outputCGImage = context.createCGImage(outputCIImage, from: bounds) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    @IBAction func addImage(_ sender: Any) {
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
            
        @unknown default:
            fatalError("Unhandled case for photo library authorization status")
        }
        presentImagePickerController()
    }
    
    private func presentImagePickerController() {
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else {
            self.presentInformationalAlertController(title: "Error", message: "The photo library or the camera is unavailable.")
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


extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        addImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.image = image
        
        updateViews()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
