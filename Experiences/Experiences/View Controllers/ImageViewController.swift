//
//  ImageViewController.swift
//  Experiences
//
//  Created by Vici Shaweddy on 1/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import Photos
import CoreImage.CIFilterBuiltins

class ImageViewController: UIViewController {

    // MARK: - Outlets and Properties
    
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saturationStackView: UIStackView!
    
    var post: Post?
    var postController: PostController?
    private let locationManager = CLLocationManager()
    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            
            var scaledSize = imageView.bounds.size
            let scale = CGFloat(0.5)
            
            scaledSize = CGSize(width: scaledSize.width * scale,
                                height: scaledSize.height * scale)
            
            let scaledUIImage = originalImage.imageByScaling(toSize: scaledSize)
            guard let scaledCGImage = scaledUIImage?.cgImage else { return }
            
            scaledImage = CIImage(cgImage: scaledCGImage)
        }
    }
    
    var scaledImage: CIImage? {
        didSet {
            updateImage()
        }
    }
    
    private let colorControlsFilter = CIFilter.colorControls()
    private let context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = imageView.image
        
        // hide the filter
        self.saturationStackView.isHidden = true
    }
    
    // MARK: - Functions
    
    private func image(byFiltering inputImage: CIImage) -> UIImage {

        colorControlsFilter.inputImage = inputImage
        colorControlsFilter.saturation = saturationSlider.value
        
        guard let outputImage = colorControlsFilter.outputImage else { return UIImage(ciImage: inputImage) }
        
        guard let renderedImage = context.createCGImage(outputImage, from: outputImage.extent) else { return UIImage(ciImage: inputImage) }
        
        return UIImage(cgImage: renderedImage)
    }
    
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            imageView.image = image(byFiltering: scaledImage)
        } else {
            imageView.image = nil
        }
    }
    
    func presentImagePickerController () {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else
        {
            // make as an alert
            print("The photo library isn't available.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func addImageFromLibraryPressed(_ sender: Any) {
        self.presentImagePickerController()
    }    

    @IBAction func nextPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add a Title", message: nil, preferredStyle: .alert)
                
                var titleTextField: UITextField?
                
                alert.addTextField { (textField) in
                    textField.placeholder = "Type your title"
                    titleTextField = textField
                }
                
                let addTitleAction = UIAlertAction(title: "Save", style: .default) { (_) in
                    
                    guard let title = titleTextField?.text,
                        let image = self.imageView.image else { return }
                                        
                    let post = Post(title: title, media: .image(image: image))
                    
                    self.postController?.savePost(post)
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(addTitleAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Slider events
    
    @IBAction func saturationChanged(_ sender: Any) {
        self.updateImage()
    }
}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // if user cancels the action so dismiss
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // check if there is original image or not
        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        // show saturation filter
        self.saturationStackView.isHidden = false
        
        picker.dismiss(animated: true, completion: nil)
    }
}
