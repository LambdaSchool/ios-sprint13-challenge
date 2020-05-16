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
    
//    @IBAction func selectImage(_ sender: UIButton) {
//
//        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
//
//        switch authorizationStatus {
//        case .authorized:
//
//        default:
//            <#code#>
//        }
//    }
    
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
