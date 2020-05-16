//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Alex Thompson on 5/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins
import MapKit

class NewExperienceViewController: UIViewController {
    
    var mapVC: MapViewController?
    var userLocation: CLLocationCoordinate2D?
    private let context = CIContext()
    private let exposureAdjustFilter = CIFilter.exposureAdjust()
    private var selectedImage: UIImage? {
        didSet {
            guard let selectedImage = selectedImage else { return }
            
            var scaledSize = photoImage.bounds.size
            let scale = UIScreen.main.scale
            
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            
            let scaledUIImage = selectedImage.imageByScaling(toSize: scaledSize)
            guard let scaledCGImage = scaledUIImage?.cgImage else { return }
            
            scaledImage = CIImage(cgImage: scaledCGImage)
        }
    }
    
    private var scaledImage: CIImage? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var addPosterButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImage(_ sender: UIButton) {

        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library.")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library you must allow us to access it.")
                    return
                }
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow us to access it.")
            
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. You're device's restrictions do not allow access")
        @unknown default:
            preconditionFailure("The app does not handle this new case provided by apple.")
        }
        presentImagePickerController()
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        
        guard titleTextField.text != "" else {
            presentInformationalAlertController(title: "Error", message: "Cannot have text field empty")
            
            return
        }
        
        performSegue(withIdentifier: "RecordSegue", sender: self)
    }
    
    
    
    private func updateViews() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
