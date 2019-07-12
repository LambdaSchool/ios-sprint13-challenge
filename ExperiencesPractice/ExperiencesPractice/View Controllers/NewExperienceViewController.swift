//
//  NewExperienceViewController.swift
//  ExperiencesPractice
//
//  Created by John Pitts on 7/12/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit
import Photos
//import CoreImage

class NewExperienceViewController: UIViewController {

    @IBOutlet weak var experienceTitleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var audioRecordButton: UIButton!
    
    let authorizationStatus = PHPhotoLibrary.authorizationStatus()
    let context = CIContext(options: nil)
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        
        // authorization from user to access image-Picker
        establishAuthorization()
        
        
        // updateView() or simply display image here since other things aren't happening
        
    }
    
    private func establishAuthorization() {
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                guard status == .authorized else {
                    NSLog("User said no")
                    self.presentInformationalAlertController(title: "Error", message: "To use a photo you must allow this application to access your photo library on this device")
                    return
                }
                self.presentImagePickerController()
            }
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "To use a photo experience you must authorize your photo library to be accessed by this app")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "you don't have permission to access photos")
        default: print("whoops, didn't think of this authorization problem, investigate")
        }
        presentImagePickerController()  // not sure this makes sense here in certain cases above
    }
    
    
    func presentImagePickerController() {
        
        let imagePicker = UIImagePickerController()
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "Photo Library unavailable")
            return
        }
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func filterAndPresentImage(image: UIImage) {
        
        
        
    }
    
    func updateViews() {
        
        // display image if returning from image selection
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func imageRender(byFiltering image: UIImage, with filter: CIFilter) -> UIImage {
        // let ciImage = originalImage?.ciImage Won't work from the Photo Library!
        
        guard let cgImage = image.flattened.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: "inputImage")  // key MUST match the API, so refer to developer.apple Core Image
        
        guard let outputCIImage = filter.outputImage else { return image }
        
        // render the image
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        return UIImage(cgImage: outputCGImage)
        
    }

}




extension NewExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        guard let imageFilterPETonal = CIFilter(name: "CIPhotoEffectChrome") else { return }
        
        let filteredImage = imageRender(byFiltering: image, with: imageFilterPETonal)
        
        imageView.image = filteredImage
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
