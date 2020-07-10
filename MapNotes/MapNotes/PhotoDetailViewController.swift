//
//  PhotoDetailViewController.swift
//  MapNotes
//
//  Created by Thomas Sabino-Benowitz on 7/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import CoreLocation
import MapKit

class PhotoDetailViewController: UIViewController, UINavigationControllerDelegate {
    private let context = CIContext(options: nil)

    var mapNoteController: MapNoteController?
    
    private var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else {
                scaledImage = nil
                return
            }
            
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    
    private var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    var coordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var sepiaIntensitySlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
        
        originalImage = imageView.image
        print("Bounds: \(UIScreen.main.bounds)")
        print("Scale: \(UIScreen.main.scale)")
    }
    
    func updateImage() {
        if let originalImage = originalImage {
            imageView.image = filterImage(originalImage)
        } else {
            imageView.image = nil
        }
    }
    
    func filterImage(_ image: UIImage) -> UIImage? {
        
        //        first we get the cGImage from the UIImage (UIImage -> CGImage -> CIImage)
        
        guard let cgImage = image.cgImage else { return nil }
        
        
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.sepiaTone() // may not work for some custom filters
        
        print("filter")
        //             print(filter.attributes)
        
        filter.inputImage = ciImage
        filter.intensity = sepiaIntensitySlider.value
      
        //        CIImage -> CGImage -> UIImage
        guard let outputCIImage = filter.outputImage else { return nil }
        
        // Render image
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else {return nil}
        
        return UIImage(cgImage: outputCGImage)
        
        
    }
    
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func choosePhotoPressed(_ sender: Any) {
          showImagePicker()
    }

    @IBAction func savePhotoPressed(_ sender: Any) {
            saveAndFilterPhoto()
    }
    

    
    private func saveAndFilterPhoto() {
        
        guard let originalImage = originalImage else {return}
        
        guard let processedImage = filterImage(originalImage) else {return}
        
        print("\(mapNoteController)")
        
        mapNoteController!.createMapNote(title: "Photo MapNote", coordinate: coordinates, imageData: processedImage.jpegData(compressionQuality: 0))
        
        
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {return} // TODO handle other cases
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: processedImage)
                
            }) { (success, error) in
                if let error = error {
                    print("Error saving photo: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    print("Saved photo")
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Slider events
    @IBAction func sepiaIntensityChanged(_ sender: UISlider) {
        updateImage()
    }
    
}

extension UIImagePickerController.InfoKey {
    
}

extension PhotoDetailViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
