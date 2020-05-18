//
//  CreateExperienceViewController.swift
//  Experiences
//
//  Created by Joshua Rutkowski on 5/17/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit

class CreateExperienceViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var experienceImageView: UIImageView!
    @IBOutlet var recordAudioButton: UIButton!
    
    //Mark: - Properties
    var experienceController: ExperienceController?
    var experience: Experience?
    var experienceTitle: String?
    var latitude: Double?
    var longitude: Double?
    var audioExtension: String?
    var photoExtension: String?
    var image = ""
    var originalImage: UIImage? {
        didSet {
            savePhoto()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - Image
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func savePhoto() {
        guard let originalImage = originalImage else { return }
        
        let processedImage = filterImage(originalImage)
        
        guard let imageData = processedImage.pngData() else { return }
        
        self.image = UUID().uuidString
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(image).appendingPathExtension("png")
        
        try? imageData.write(to: fileURL)
    }

    private func filterImage(_ image: UIImage) -> UIImage {
        
        let filter = CIFilter(name: "CIHueAdjust")!
        let context = CIContext(options: nil)
        
        guard let cgImage = image.cgImage else { return image }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(Float(3.141592653589793), forKey: kCIInputAngleKey)
        
        guard let outputCIImage = filter.outputImage else { return image }
        
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return image }
        
        experienceImageView.image = UIImage(cgImage: outputCGImage)
        
        return UIImage(cgImage: outputCGImage)
    }

    
    //MARK: - IBActions

    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: Any) {
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    
}

//MARK: - Extensions

extension CreateExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
