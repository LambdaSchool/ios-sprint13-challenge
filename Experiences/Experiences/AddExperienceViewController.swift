//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Dahna on 7/10/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class AddExperienceViewController: UIViewController {
    
    // MARK: Properties
    
    private let context = CIContext(options: nil)
    
    // MARK: Outlets
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Actions
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        presentImagePicker()
    }
    
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Image
    
     func image(byFiltering image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image}
        
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.photoEffectNoir()
        
        filter.inputImage = ciImage
        
        guard let outputImage = filter.outputImage else { return image }
        
        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let viewImage = info[.originalImage] as? UIImage else { return }
        
        imageView.image = image(byFiltering: viewImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
