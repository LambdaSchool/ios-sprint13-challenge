//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Jordan Christensen on 11/1/19.
//  Copyright © 2019 Mazjap Co. All rights reserved.
//

import UIKit
import CoreImage
import Photos
import MapKit

protocol ExperienceDelegate {
    func newExperience(name: String, image: UIImage)
}

class AddExperienceViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var playAudioButton: UIButton!
    
    var delegate: ExperienceDelegate?
    
    private let context = CIContext(options: nil)
    
    var originalImage: UIImage? {
        didSet {
            guard let image = originalImage else { return }
            
            var scaledSize = experienceImageView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = image.imageByScaling(toSize: scaledSize)
        }
    }
    
    var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playAudioButton.isHidden = true
    }
    
    private func updateImage() {
        if let image = scaledImage {
            experienceImageView.image = filterImage(image)
        }
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is not available")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }
    
    private func filterImage(_ image: UIImage) -> UIImage? {
        let filter = CIFilter(name: "CIColorControls")!
        let ciImage = CIImage(image: image)
        filter.setValue(ciImage, forKey: "inputImage")
        filter.setValue(2.0, forKey: "inputSaturation")
        filter.setValue(0.6, forKey: "inputBrightness")
        filter.setValue(2.5, forKey: "inputContrast")
        guard let outputImage = filter.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    @IBAction func addImageTapped(_ sender: UIButton) {
        presentImagePickerController()
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        
    }
    
    @IBAction func toggleAudio(_ sender: UIButton) {
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = titleTextField.text else {
            print("Title gotta be there homie")
            return
        }
        guard let image = experienceImageView.image else {
            print("Image is required, sorry man. I dont make the rules")
            return
        }
        
        delegate?.newExperience(name: name, image: image)
        navigationController?.popViewController(animated: true)
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

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true)
    }
}
