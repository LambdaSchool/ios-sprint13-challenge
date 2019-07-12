//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Sameera Roussi on 7/12/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit
import Photos

class NewExperienceViewController: UIViewController {
    
    // MARK: - Properties
    var originalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    private let filter = CIFilter(name: "CIColorControls")
    private let context = CIContext(options: nil)
    
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    
    // MARK: - View states
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Dismiss keyboard after typing in textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    // MARK: Actions
    // Add Poster image button
    @IBAction func addPosterImageButtonTapped(_ sender: UIButton) {
        let sourceSelect = UIAlertController(title: "Select Source", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        // Select an image from the photo library
        let photoLibrarySource = UIAlertAction(title: "Photo Library", style: .default) { (action: UIAlertAction) in
            self.selectImageFromPhotoLibrary("Photo Library")
        }
        
        // Select an image from the camera
        let cameraSource = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            self.selectImageFromPhotoLibrary("Camera")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sourceSelect.addAction(photoLibrarySource)
        sourceSelect.addAction(cameraSource)
        sourceSelect.addAction(cancelAction)
        self.present(sourceSelect, animated: true, completion: nil)
    }
    
    // Add Record button
    @IBAction func recordButtonTapped(_ sender: Any) {
    }
    
    
    // MARK: - Functions
    private func selectImageFromPhotoLibrary(_ photoSource: String) {
        if photoSource == "Photo Library" {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                NSLog("The photo library is not available")
                return
            }
        } else  {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                NSLog("The camera photos are not available")
                return
            }
        }
        // Get the image
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        // If we can't get the image just return the original
        guard let cgImage = image.flattened.cgImage else { return image }
        // Convert the CGImage to a CIImage so that a filter can be applied.
        let ciImage = CIImage(cgImage: cgImage)
        
        // set the filter properties
        filter?.setValue(ciImage, forKey: "inputImage")
        filter?.setValue(0, forKey: "inputSaturation")
        filter?.setValue(0.122, forKey: "inputBrightness")
        filter?.setValue(1.2, forKey: "inputContrast")
        
        // Return the image unrendered
        guard let outputCIImage = filter?.outputImage else { return image }
        
        // Render the image (apply the filter)
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        
        // Wrap up the CGImage to a UIImage
        return UIImage(cgImage: outputCGImage)
    }
    
    func updateImage() {
        // Make sure we have an image
        if let originalImage = originalImage {
            imageView.image = image(byFiltering: originalImage)
            addImageButton.setTitle("", for: .normal)
        }
        else { imageView.image = nil }
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

extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as?  UIImage {
            originalImage = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

extension UIImage {
    
    /// Resize the image to a max dimension from size parameter
    func imageByScaling(toSize size: CGSize) -> UIImage? {
        
        guard let data = flattened.pngData(),
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
                return nil
        }
        
        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
            kCGImageSourceCreateThumbnailFromImageAlways: true
        ]
        
        return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary).flatMap { UIImage(cgImage: $0) }
    }
    
    /// Renders the image if the pixel data was rotated due to orientation of camera
    var flattened: UIImage {
        if imageOrientation == .up { return self }
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { context in
            draw(at: .zero)
        }
    }
}
