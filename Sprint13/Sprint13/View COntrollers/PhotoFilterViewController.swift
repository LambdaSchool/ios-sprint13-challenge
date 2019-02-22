//
//  ViewController.swift
//  PhotoFilter
//
//  Created by Sergey Osipyan on 2/18/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import CoreImage
import UIKit
import Photos

class PhotoFilterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var originalImage: UIImage? {
        didSet {
            updateImageView()
        }
    }
    private let filter = CIFilter(name: "CIColorControls")!
    private let context = CIContext(options: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationSlider(brightnessSliderOutlet, from: filter.attributes[kCIInputBrightnessKey])
        configurationSlider(contrastSliderOutlet, from: filter.attributes[kCIInputContrastKey])
        configurationSlider(saturationSliderOutlet, from: filter.attributes[kCIInputSaturationKey])
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var brightnessSliderOutlet: UISlider!
    @IBOutlet weak var contrastSliderOutlet: UISlider!
    @IBOutlet weak var saturationSliderOutlet: UISlider!
    
    
    @IBAction func savePhoto(_ sender: Any) {
        guard let originalImage = originalImage else { return }
        let image = applyFilter(to: originalImage)
        
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: image)
            }, completionHandler: { (success, error) in
                if let error = error {
                    NSLog("Error saving photo: \(error)")
                    return
                }
                NSLog("Saving photo Succeeded")
            })
            
        }
        
        
    }
    
   
    @IBAction func choosePhotoButton(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is unavailable")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
   
    
    private func configurationSlider(_ slider: UISlider, from attributes: Any) {
        
        let attrs = attributes as? [String: Any] ?? [:]
        
        if let min = attrs[kCIAttributeSliderMin] as? Float,
            let max = attrs[kCIAttributeSliderMax] as? Float,
            let value = attrs[kCIAttributeDefault] as? Float {
            
            slider.minimumValue = min
            slider.maximumValue = max
            slider.value = value
            
        } else {
            slider.minimumValue = 1
            slider.maximumValue = 1
            slider.value = 0.5
        }
        
    }
    
    private func updateImageView() {
        guard let image = originalImage else { return}
        imageView.image = applyFilter(to: image)
        
    }
    private func applyFilter(to image: UIImage) -> UIImage {
        
        let inputImage: CIImage
        if let ciImage = image.ciImage {
            inputImage = ciImage
        } else if let cgImage = image.cgImage {
            inputImage = CIImage(cgImage: cgImage)
        }else {
            //
            return image
        }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        filter.setValue(brightnessSliderOutlet.value, forKey: kCIInputBrightnessKey)
           filter.setValue(contrastSliderOutlet.value, forKey: kCIInputContrastKey)
           filter.setValue(saturationSliderOutlet.value, forKey: kCIInputSaturationKey)
        
        guard let outputImage = filter.outputImage else {
            return image
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

