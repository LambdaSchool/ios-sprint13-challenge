//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Christian Lorenzo on 5/16/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins
import MapKit

class NewExperienceViewController: UIViewController {
    
    //Properties:
    var mapVC: MapViewController?
    var userLocation: CLLocationCoordinate2D?
    private let context = CIContext()
    private let exposureAdjustFilter = CIFilter.exposureAdjust()
    private var selectedImage: UIImage? {
        didSet {
            guard let selectedImage = selectedImage else { return }
            
            var scaledSize = photoImageView.bounds.size
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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var addPosterButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If false, it'll show greyed out on the screen.
        recordButton.isEnabled = false
    }
    
    func updateViews() {
        
    }
    
    @IBAction func selectImage(_ sender: Any) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library.")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library you must allow us to access it.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow us to access it")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the library. Your devices's restrictions do not allow access.")
        default:
            preconditionFailure("The app does not handle this new case provided by apple")
        }
        
        presentImagePickerController()
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        guard titleTextField.text != "" else {
            presentInformationalAlertController(title: "Error", message: "Cannot have text field empty")
            return
        }
        
        performSegue(withIdentifier: "GoToRecordersSegue", sender: self)
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            
            //Presenting the ViewController:
            self.present(imagePicker, animated: true, completion: nil)
        }
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
