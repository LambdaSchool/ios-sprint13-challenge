//
//  ImagePostViewController.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import Photos

enum FilterType {
    case BlackWhite
    case Blur
    case Vintage
}

class ImagePostViewController: UIViewController {
    
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurSlider: UISlider!
    @IBOutlet weak var blackAndWhiteSwitch: UISwitch!
    @IBOutlet weak var vintageSwitch: UISwitch!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    let context = CIContext(options: nil)
    var imageData: Data?
    var filterType: FilterType?
    private var image: UIImage? {
        didSet {
            guard image != nil else {return}
            
            updateImage()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageViewHeight(with: 1.0)
    }

    func setImageViewHeight(with aspectRatio: CGFloat) {
        
        imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio
        
        view.layoutSubviews()
    }
    private func presentImagePickerController() {

        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        //8a00
        //6c00
        imagePicker.delegate = self

        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveImage(_ sender: Any) {
        view.endEditing(true)
//        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.1) else {
//                presentInformationalAlertController(title: "Uh-oh", message: "Make sure that you add a photo and a caption before posting.")
//                return
//        }
//        
//        postController.createPost(with: title, ofType: .image, mediaData: imageData, ratio: imageView.image?.ratio) { (success) in
//            guard success else {
//                DispatchQueue.main.async {
//                    self.presentInformationalAlertController(title: "Error", message: "Unable to create post. Try again.")
//                }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
        navigationController?.popViewController(animated: true)
    }
    func filter(_ image: UIImage, for filter: FilterType) -> UIImage? {
        switch filter {
        case .BlackWhite:
            guard let cgImage = image.cgImage else {return nil}
            let ciImage = CIImage(cgImage: cgImage)
            let filter = CIFilter(name: "CIPhotoEffectTonal")!
            filter.setValue(ciImage, forKey: "inputImage")
            guard let outputCI = filter.outputImage else { return nil }
            guard let outputCG = context.createCGImage(outputCI, from: CGRect(origin: .zero, size: image.size)) else {return nil}
            return UIImage(cgImage: outputCG)
        case .Blur:
            guard let cgImage = image.cgImage else {return nil}
            let ciImage = CIImage(cgImage: cgImage)
            let filter = CIFilter(name: "CIGaussianBlur")!
            filter.setValue(ciImage, forKey: "inputImage")
            filter.setValue(blurSlider.value, forKey: "inputRadius")
            guard let outputCI = filter.outputImage else { return nil }
            guard let outputCG = context.createCGImage(outputCI, from: CGRect(origin: .zero, size: image.size)) else {return nil}
            return UIImage(cgImage: outputCG)
        case .Vintage:
            guard let cgImage = image.cgImage else {return nil}
            let ciImage = CIImage(cgImage: cgImage)
            let filter = CIFilter(name: "CIPhotoEffectInstant")!
            filter.setValue(ciImage, forKey: "inputImage")
            guard let outputCI = filter.outputImage else { return nil }
            guard let outputCG = context.createCGImage(outputCI, from: CGRect(origin: .zero, size: image.size)) else {return nil}
            return UIImage(cgImage: outputCG)
        @unknown default:
            break
        }
    }
    
    private func updateImage() {
        if let image = image {

            switch self.filterType {
            case .BlackWhite:
                imageView.image = filter(image, for: .BlackWhite)
            case .Blur:
                imageView.image = filter(image, for: .Blur)
            case .Vintage:
                imageView.image = filter(image, for: .Vintage)
            case .none:
                imageView.image = nil
            @unknown default:
                break
            }
        }
    }
    
    @IBAction func chooseImageTapped(_ sender: Any) {
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
            print("FatalError")
        }
        presentImagePickerController()
    }
    
    @IBAction func blurSliderMoved(_ sender: Any) {
        image = imageView.image
        filterType = .Blur
        updateImage()
        
    }
    @IBAction func blackWhiteSwitchToggled(_ sender: Any) {
        image = imageView.image
        filterType = .BlackWhite
        updateImage()
    }
    @IBAction func vintageSwitchToggled(_ sender: Any) {
        image = imageView.image
        filterType = .Vintage
        updateImage()
    }
    
}
extension ImagePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
        setImageViewHeight(with: image.ratio)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
