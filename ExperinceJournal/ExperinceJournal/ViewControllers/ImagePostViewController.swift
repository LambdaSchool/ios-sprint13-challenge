//
//  ImagePostViewController.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

enum FilterType {
    case sepia
    case blackAndWhite
    case blur
    case sharpen
    case negative
}


protocol ImageViewControllerDelegate {
    func imagePostButtonWasTapped()
}

class ImagePostViewController: UIViewController {
    
    var filterType: FilterType?
    //var mapView: MapViewController!
    var entryController: EntryController?
    var imageData: Data?
    var delegate: ImageViewControllerDelegate?
    private var context = CIContext(options: nil)
    private var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    private var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    
    
    @IBOutlet weak var imageTitleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var GeoTag: UISwitch!
    @IBOutlet weak var choseImageButton: UIButton!
    @IBOutlet weak var postImageButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTitleTextField.delegate = self as? UITextFieldDelegate
        
        updateViews()
        
    }
    
    func updateViews() {
        guard let imageData = imageData else {
            title = "New Post"
            return
        }
        
        
    }
    
    
    
    
    func filter(_ image: UIImage, for type: FilterType) -> UIImage? {
        switch type {
        case .sepia:
            guard let cgImage = image.cgImage else { return nil }
            let ciImage = CIImage(cgImage: cgImage)
            let filter = CIFilter.sepiaTone()
            filter.inputImage = ciImage
            filter.intensity = valueSlider.value
            guard let outputCIImage = filter.outputImage else { return nil }
            guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
            return UIImage(cgImage: outputCGImage)
            
        case .blackAndWhite:
            guard let cgImage = image.cgImage else { return nil }
            let ciImage = CIImage(cgImage: cgImage)
            let filter = CIFilter.photoEffectNoir()
            filter.inputImage = ciImage
            guard let outputCIImage = filter.outputImage else { return nil }
            guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
            return UIImage(cgImage: outputCGImage)
            
        case .blur:
            guard let cgImage = image.cgImage else { return nil }
            let ciImage = CIImage(cgImage: cgImage)
            let filter = CIFilter.gaussianBlur()
            filter.inputImage = ciImage
            filter.radius = valueSlider.value
            guard let outputCIImage = filter.outputImage else { return nil }
            guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
            return UIImage(cgImage: outputCGImage)
            
        case .sharpen:
            guard let cgImage = image.cgImage else { return nil }
            let ciImage = CIImage(cgImage: cgImage)
            let filter = CIFilter.sharpenLuminance()
            filter.inputImage = ciImage
            filter.sharpness = valueSlider.value
            guard let outputCIImage = filter.outputImage else { return nil }
            guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
            return UIImage(cgImage: outputCGImage)
            
        case .negative:
            guard let cgImage = image.cgImage else { return nil }
            let ciImage = CIImage(cgImage: cgImage)
            let filter = CIFilter.colorInvert()
            filter.inputImage = ciImage
            guard let outputCIImage = filter.outputImage else { return nil }
            guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
            return UIImage(cgImage: outputCGImage)
            
        }
    }
    
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            switch filterType {
            case .sepia:
                imageView.image = filter(scaledImage, for: .sepia)
            case .blackAndWhite:
                imageView.image = filter(scaledImage, for: .blackAndWhite)
            case .blur:
                imageView.image = filter(scaledImage, for: .blur)
            case .sharpen:
                imageView.image = filter(scaledImage, for: .sharpen)
            case .negative:
                imageView.image = filter(scaledImage, for: .negative)
            default:
                break
            }
        } else {
            imageView.image = nil
        }
    }
    
    
    
    @IBAction func choseImageButton(_ sender: UIButton) {
        
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
            break
            
        }
        presentImagePickerController()
        
    }
    
    
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = .photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func sharpenButtonTapped(_ sender: UIButton) {
        originalImage = imageView.image
        valueSlider.minimumValue = 0
        valueSlider.maximumValue = 2
        valueSlider.value = 0.4
        filterType = .sharpen
    }
    
    @IBAction func postButtonTapped(_ sender: UIBarButtonItem) {
        addImage()
    }
    
    
    @IBAction func invertButtonTapped(_ sender: UIButton) {
        originalImage = imageView.image
        valueSlider.removeFromSuperview()
        filterType = .negative
        updateImage()
    }
    
    
    
    @IBAction func blurButtonTapped(_ sender: UIButton) {
        originalImage = imageView.image
        valueSlider.minimumValue = 0
        valueSlider.maximumValue = 100
        valueSlider.value = 0
        filterType = .blur
        
    }
    
    
    
    @IBAction func blackAndWhiteTapped(_ sender: UIButton) {
        originalImage = imageView.image
        valueSlider.removeFromSuperview()
        filterType = .blackAndWhite
        updateImage()
    }
    
    
    @IBAction func sepiaButtonTapped(_ sender: UIButton) {
        originalImage = imageView.image
        valueSlider.minimumValue = 0
        valueSlider.maximumValue = 1
        valueSlider.value = 0
        filterType = .sepia
    }
    
    @IBAction func valueSliderChanged(_ sender: UISlider) {
        updateImage()
    }
    
    func addImage() {
        view.endEditing(true)
        
        guard let title = imageTitleTextField.text, !title.isEmpty else {
            presentInformationalAlertController(title: "Title Needed", message: "Please add a title to your experience")
            return
        }
        
        if GeoTag.isOn {
            LocationHelper.shared.getCurrentLocation { (coordinate) in
                EntryController.shared.createPost(with: title, ofType: .image, location: coordinate)
                self.delegate?.imagePostButtonWasTapped()
                self.dismiss(animated: true)
            }
        } else {
            EntryController.shared.createPost(with: title, ofType: .image, location: nil)
            self.delegate?.imagePostButtonWasTapped()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

extension ImagePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        choseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
        //setImageViewHeight(with: image.ratio)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn( _ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
