//
//  ImageVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

protocol ImageDelegate: AnyObject {
    func addImage(image: UIImage)
}

class ImageVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var chooseImageButton: UIButton!
    @IBOutlet private var saveImageButton: UIButton!
    @IBOutlet private var hueSlider: UISlider!
    @IBOutlet private var crystalSlider: UISlider!
    
    // MARK: - Properties
    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else {
                scaledImage = nil
                return
            }
            var scaledSize = imageView.bounds.size
            let scale = imageView.contentScaleFactor
            scaledSize.width *= scale
            scaledSize.height *= scale
            
            guard let scaledUIImage = originalImage.imageByScaling(toSize: scaledSize) else {
                scaledImage = nil
                return
            }
            scaledImage = CIImage(image: scaledUIImage)
        }
    }
    
    var scaledImage: CIImage? {
        didSet {
            if let scaledImage = scaledImage {
                imageView.image = UIImage(ciImage: scaledImage)
            }
        }
    }

    private let context = CIContext()
    weak var delegate: ImageDelegate?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = imageView.image
    }
    
    // MARK: - Actions
    
    @IBAction func chooseImage(_ sender: UIButton) {
        presentImagePickerController()
    }

    @IBAction func saveImage(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        delegate?.addImage(image: image)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func blackAndWhite(_ sender: UIButton) {
        guard let scaledImage = scaledImage else { return }
        imageView.image = blackAndWhite(byFiltering: scaledImage)
    }
    
    @IBAction func changeHueSliderValue(_ sender: UISlider) {
        guard let scaledImage = scaledImage else { return }
        imageView.image = hueAdjust(byFiltering: scaledImage)
    }
    
    @IBAction func changeCrystalSliderValue(_ sender: UISlider) {
        guard let scaledImage = scaledImage else { return }
        imageView.image = crystallize(byFiltering: scaledImage)
    }
    
    // MARK: - Private Functions
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func blackAndWhite(byFiltering inputImage: CIImage) -> UIImage? {
        let blackAndWhiteFilter = CIFilter.photoEffectNoir()
        blackAndWhiteFilter.inputImage = inputImage
        guard let outputImage = blackAndWhiteFilter.outputImage else { return nil }
        guard let renderedCGImage = context.createCGImage(outputImage, from: inputImage.extent) else { return nil }
        return UIImage(cgImage: renderedCGImage)
    }
    
    private func hueAdjust(byFiltering inputImage: CIImage) -> UIImage? {
        let hueAdjustFilter = CIFilter.hueAdjust()
        hueAdjustFilter.inputImage = inputImage
        hueAdjustFilter.angle = hueSlider.value
        guard let outputImage = hueAdjustFilter.outputImage else { return nil }
        guard let renderedCGImage = context.createCGImage(outputImage, from: inputImage.extent) else { return nil }
        return UIImage(cgImage: renderedCGImage)
    }
    
    private func crystallize(byFiltering inputImage: CIImage) -> UIImage? {
        let crystallizeFilter = CIFilter.crystallize()
        crystallizeFilter.inputImage = inputImage
        crystallizeFilter.radius = crystalSlider.value
        guard let outputImage = crystallizeFilter.outputImage else { return nil }
        guard let renderedCGImage = context.createCGImage(outputImage, from: inputImage.extent) else { return nil }
        return UIImage(cgImage: renderedCGImage)
    }
    
}

extension ImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
}
