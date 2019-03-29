//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Angel Buenrostro on 3/29/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit
import Photos

class NewExperienceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.isEnabled = false
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addPhotoPressed(_ sender: Any) {
        print("add photo pressed")
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
            
        }
        presentImagePickerController()
    }
    @IBAction func recordAudioPressed(_ sender: Any) {
    }
    @IBAction func photoFilterPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add a filter", message: nil, preferredStyle: .actionSheet)
        
        let fadeAction = UIAlertAction(title: "Fade", style: .default) { (_) in
            self.filterImage(withFilter: .fade)
//            self.setViewsForFilter()
        }
        
        let exposureAdjustAction = UIAlertAction(title: "Exposure", style: .default) { (_) in
            self.filterImage(withFilter: .exposure, parameters: [kCIInputEVKey: 0.0])
//            self.setViewsForFilter()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(fadeAction)
        alert.addAction(exposureAdjustAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    var currentFilter: ImageFilter = .none
    
    enum ImageFilter: String {
        case fade = "CIPhotoEffectFade"
        case exposure = "CIExposureAdjust"
        case none
        
        static var allFilters: [ImageFilter] = [.fade]
    }
    
    func filterImage(withFilter filter: ImageFilter, parameters: [String: CGFloat] = [:]) {
        
        guard let image = imageView.image else { return }
        
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
            
            currentFilter = filter
        }
    }
    
    let context = CIContext(options: nil)
    
//    func setViewsForFilter() {
//
//        switch currentFilter {
//        case .fade, .none:
//            filterLabel.isHidden = true
//            filterSlider.isHidden = true
//        case .exposure:
//
//
//            filterLabel.isHidden = false
//            filterSlider.isHidden = false
//
//            filterSlider.minimumValue = -2.5
//            let value = CGFloat((filterSlider.value * 1000).rounded() / 1000)
//
//            filterLabel.text = "Exposure: \(value) EV"
//
//            filterSlider.maximumValue = 2.5
//
//        }
//    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var photoFilterButton: UIButton!
    
    var originalImage: UIImage?
    var imageData: Data?
}


extension UIViewController {
    
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: completion)
    }
}

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        addPhotoButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        originalImage = image
        recordButton.isEnabled = true
        photoFilterButton.isEnabled = true
        
//        setImageViewHeight(with: image.ratio)
//        addFilterButton.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
