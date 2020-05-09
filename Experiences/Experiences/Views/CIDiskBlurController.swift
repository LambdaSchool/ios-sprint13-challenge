//
//  PhotoFilterViewController.swift
//  ImageManipulator
//
//  Created by Lambda_School_Loaner_268 on 5/4/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import Foundation

class DiscBlurViewController: UIViewController {
    

    @IBAction func nextButton(_ sender: Any) {
        ExperienceController.shared.image = imageView.image
        ExperienceController.shared.postTitle = titleTF.text
        ExperienceController.shared.description = descriptionTF.text
        performSegue(withIdentifier: "firstToSecond",
                     sender: (Any).self)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func addImageButon(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    
    let context = CIContext(options: nil)
    
    func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "firstToSecond" {
            ExperienceController.shared.postTitle = titleTF.text
            ExperienceController.shared.description = descriptionTF.text
            let _ = segue.destination as? CameraController
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        originalImage = imageView.image
    }
    
    
    var originalImage: UIImage? {
        didSet {
            // resize the scaledImage and set it
            guard let originalImage = originalImage else { return }
            
            // Height and width
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale  // 1x, 2x, or 3x
            
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            print("scaled size: \(scaledSize)")
            
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)

        }
    }
        
    var scaledImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    
    
    
    
    // filterImage(originalImage)

    // Create a stub with default return is a good way to start
    private func filterImage(_ image: UIImage) -> UIImage? {
        
        
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter(name: "CIDiscBlur")
        
        filter?.setValue(ciImage,
                         forKey: kCIInputImageKey)
        filter?.setValue(NSNumber(10),
                         forKey: kCIInputRadiusKey)
        
        
        // CIImage -> CGImage -> UIImage
        
        // guard let outputCIImage = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        guard let outputCIImage = filter?.outputImage else { return nil }
        
        print(outputCIImage.url)
        
        // Render the image (do image processing here)
        guard let outputCGImage = context.createCGImage(outputCIImage,
                                                        from: CGRect(origin: .zero, size: image.size)) else {
            return nil
        }
        ExperienceController.shared.image = UIImage(cgImage: outputCGImage)
        print(ExperienceController.shared.image)
        return UIImage(cgImage: outputCGImage)
    }
    
    private func updateViews() {
        if let scaledImage = scaledImage {
            imageView.image = filterImage(scaledImage)
        } else {
           imageView.image = nil
        }
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: The photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        presentImagePickerController()
    }




    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension DiscBlurViewController: UINavigationControllerDelegate {
    
}

extension DiscBlurViewController: UIImagePickerControllerDelegate {
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let image = info[.originalImage] as? UIImage {
        originalImage = image    }
   
    picker.dismiss(animated: true)
    }
}
