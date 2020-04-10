//
//  PhotoViewController.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit
import Photos
import CoreImage.CIFilterBuiltins

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    let photoController = PhotoController()
    var experienceController: ExperienceController?
    var geoTag: GeoTag?
    var descriptionText: String?
    var photoData: Data?
    
    private var context = CIContext(options: nil)
    private var originalImage: UIImage? {
        didSet {
            guard let imageData = photoData,
                let originalImage = UIImage(data: imageData) else { return }
            
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    
    private var scaledImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
            
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    return
                }
                self.presentImagePickerController()
            }
        default:
            break
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let experienceController = experienceController,
            let geoTag = geoTag,
            let descriptionText = descriptionText,
            !descriptionText.isEmpty,
            let photo = scaledImage else { return }
        let newEntry = experienceController.createExperience(geoTag: geoTag,
                                                             description: descriptionText,
                                                             photo: photo)
        experienceController.experience = newEntry
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        if let scaledImage = scaledImage {
            imageView.image = scaledImage
        } else {
            imageView.image = nil
            title = "New Post"
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        // Go from UIImage to CIImage
        guard let image = info[.originalImage] as? UIImage,
            let cgImage = image.cgImage else { return }
        
        let ciImage = CIImage(cgImage: cgImage)
        let imageFilter = CIFilter.colorControls()
        
        // Configure filter
        imageFilter.setValue(0.25,
                             forKey: kCIInputBrightnessKey)
        imageFilter.inputImage = ciImage
        
        // Go from CIImage to UIImage
        guard let fitleredImage = imageFilter.outputImage,
            let outputImage = context.createCGImage(fitleredImage,from: CGRect(origin: .zero, size: image.size)) else { return }
        imageView.image = UIImage(cgImage: outputImage)
    }
    
    // MARK: - Private Methods
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func setImageViewHeight(with aspectRatio: CGFloat) {
        
        imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio
    }
}

extension UIImage {
    
    /// Resize the image to a max dimension from size parameter
    func imageByScaling(toSize size: CGSize) -> UIImage? {
        guard size.width > 0 && size.height > 0 else { return nil }
        
        let originalAspectRatio = self.size.width/self.size.height
        var correctedSize = size
        
        if correctedSize.width > correctedSize.width*originalAspectRatio {
            correctedSize.width = correctedSize.width*originalAspectRatio
        } else {
            correctedSize.height = correctedSize.height/originalAspectRatio
        }
        
        return UIGraphicsImageRenderer(size: correctedSize, format: imageRendererFormat).image { context in
            draw(in: CGRect(origin: .zero, size: correctedSize))
        }
    }
}
