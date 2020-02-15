//
//  PictureViewController.swift
//  Experiences
//
//  Created by brian vilchez on 2/14/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins
import MapKit
class PictureViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var blurSLider: UISlider!
    @IBOutlet weak var vignetteSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    private let context = CIContext(options: nil)
    var experienceController: ExperienceController?
    let locationManager = CLLocationManager()
    var originalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func photosIconPressed(_ sender: Any) {
        presentActionSheet()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let title = titleTextfield.text, let image = imageVIew.image else { return }
        let location = locationManager.location?.coordinate
       experienceController?.createExperience(withTitle: title, image:image , audioRecording: nil, videoRecording: nil, location: location)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func blurSliderMoved(_ sender: UISlider) {
        updateImage()
    }
    
    @IBAction func secondSLiderMoved(_ sender: UISlider) {
        updateImage()
    }
    
    @IBAction func thirdSliderMoved(_ sender: UISlider) {
        updateImage()
    }
    
    // MARK - Helper Methods
    private func updateImage() {
        guard let orginalImage = originalImage else { return }
        imageVIew.image = filterImage(orginalImage)
    }
    
    private func presentActionSheet() {
        let alertVC = UIAlertController(title: "Choose option", message: "", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.camera()
        }
        
        let photoLibraryAction = UIAlertAction(title: "PhotoLibrary", style: .default) { (_) in
            self.photoLibrary()
        }
        alertVC.addAction(cameraAction)
        alertVC.addAction(photoLibraryAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func filterImage( _ image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image}
        let ciImage = CIImage(cgImage: cgImage)
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = ciImage
        blurFilter.radius = blurSLider.value
        
        let vignetteFilter = CIFilter.vignette()
        vignetteFilter.inputImage = blurFilter.outputImage
        vignetteFilter.intensity = vignetteSlider.value
        
        let contrastFilter = CIFilter.colorControls()
        contrastFilter.inputImage = vignetteFilter.outputImage
        contrastFilter.contrast = contrastSlider.value
        
        guard  let outputCIImage = contrastFilter.outputImage else { return image}
        
        guard let CGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return image }
        let filteredImage = UIImage(cgImage: CGImage)
        return filteredImage
    }
    
    private func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension PictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.originalImage = image
            self.imageVIew.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
