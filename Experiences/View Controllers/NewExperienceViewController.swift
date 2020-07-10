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

        recordButton.isEnabled = false
    }
    
    func updateViews() {
        
    }
    
//    @IBAction func selectImage(_ sender: Any) {
//        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
//
//        switch authorizationStatus {
//        case .authorized:
//
//        default:
//            <#code#>
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func presntImagePickerController() {
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
