//
//  AddExperience.swift
//  Experiences
//
//  Created by Norlan Tibanear on 11/16/20.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins


class AddExperience: UIViewController {
    
    // Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sepiaSlider: UISlider!
    @IBOutlet weak var hueSlider: UISlider!
    
    
    // Properties

    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else {
                scaledImage = nil
                return
            }
            
            var scaledSize = imageView.bounds.size
            let scale = imageView.contentScaleFactor
            
            scaledSize = CGSize(width: scaledSize.width*scale, height: scaledSize.height*scale)
            
            guard let scaledUIImage = originalImage.imageByScaling(toSize: scaledSize) else {
                scaledImage = nil
                return
            }
            
            scaledImage = CIImage(image: scaledUIImage)
        }
    }
    
    var scaledImage: CIImage? {
        didSet{
            if let scaledImage = scaledImage {
                imageView.image = UIImage(ciImage: scaledImage)
            }
           // updateImage()
        }
    }
    
    
    let context = CIContext()
    
//    private let colorControlsFilter = CIFilter.colorControls()
//    
//    private let saturationFilter = CIFilter.saturationBlendMode()
//    private let brightnessFilter = CIFilter.saturationBlendMode()


    override func viewDidLoad() {
        super.viewDidLoad()

        originalImage = imageView.image
        
        selectImage()
        
//        setImageViewHeight(with: 1.0)
    }
    
//    private func image(byFiltering inputImage: CIImage) -> UIImage {
//        colorControlsFilter.inputImage = inputImage
//        colorControlsFilter.brightness = brightnessSlider.value
//        colorControlsFilter.saturation = saturationSlider.value
//
//
//        guard let outputImage = saturationFilter.outputImage else { return originalImage! }
//        guard let renderImage = context.createCGImage(outputImage, from: inputImage.extent) else { return originalImage! }
//
//        return UIImage(cgImage: renderImage)
//    }
    
    
//    private func updateImage() {
//        if let scaledImage = scaledImage {
//            imageView.image = image(byFiltering: scaledImage)
//        } else {
//            imageView.image = nil
//        }
//    }
    
    
    func selectImage() {
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func sepiaImage(byFiltering inputImage: CIImage) -> UIImage? {
        let sepia = CIFilter.sepiaTone()
        sepia.inputImage = inputImage
        
        sepia.inputImage = sepia.outputImage?.clampedToExtent()
        sepia.intensity = sepiaSlider.value
        
        guard let outputImage = sepia.outputImage else { return nil }
        guard let renderCIImage = context.createCGImage(outputImage, from: inputImage.extent) else { return nil }
        return UIImage(cgImage: renderCIImage)
    }//
    
    private func hueImage(byFiltering inputImage: CIImage) -> UIImage? {
        let hue = CIFilter.hueAdjust()
        hue.inputImage = inputImage
        
        hue.inputImage = hue.outputImage?.clampedToExtent()
        hue.angle = hueSlider.value
        
        guard let outputImage = hue.outputImage else { return nil }
        guard let renderCIImage = context.createCGImage(outputImage, from: inputImage.extent) else { return nil }
        
        return UIImage(cgImage: renderCIImage)
    }//
    


    @IBAction func addExperience(_ sender: UIButton) {
        guard let title = titleTextField.text else { return }

    }
    
    @IBAction func sepiaChanged(_ sender: UISlider) {
        guard let scaledImage = scaledImage else { return }
        imageView.image = sepiaImage(byFiltering: scaledImage)
    }
    
    @IBAction func hueChanged(_ sender: UISlider) {
        guard let scaledImage = scaledImage else { return }
        imageView.image = hueImage(byFiltering: scaledImage)
    }
    
    
}//


extension AddExperience: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        
        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}//
