//
//  ImagesViewController.swift
//  Experiences
//
//  Created by Sal B Amer on 5/15/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ImagesViewController: UIViewController {
  
  var experienceController: ExperienceController?
  let locationManager = CLLocationManager()
  var experienceNoteTitle2 = ""
  private let context = CIContext()
  private let colorControlsFilter = CIFilter.colorControls()
  private let blurFilter = CIFilter.gaussianBlur()
  
  //MARK: Outlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleFromMain: UILabel!
  @IBOutlet weak var brightnessSlider: UISlider!
  @IBOutlet weak var contrastSlider: UISlider!
  @IBOutlet weak var saturationSlider: UISlider!
  @IBOutlet weak var blurSlider: UISlider!
  @IBOutlet weak var mysterySlider: UISlider!
  
  var originalImage: UIImage? {
    didSet {
      guard let originalImage = originalImage else { return }
      var scaledSize = imageView.bounds.size
      //      let scale: CGFloat = 0.5 / UIScreen.main.scale
      let scale: CGFloat = UIScreen.main.scale
      
      scaledSize = CGSize(width: scaledSize.width*scale,
                          height: scaledSize.height*scale)
      
      guard let scaledUIImage = originalImage.imageByScaling(toSize: scaledSize) else { return } // tell user why image did not work did not impliment but should in production
      scaledImage = CIImage(image: scaledUIImage)
    }
  }
  
  var scaledImage: CIImage? {
    didSet {
      updateImage()
    }
  }
  
  
  func updateImage() {
    if let scaledImage = scaledImage {
      imageView.image = image(byFiltering: scaledImage)
    } else {
      imageView.image = nil
    }
  }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = imageView.image // update image placeholder at all times
    }
  
  // MARK: Helper Method to present Image Picker
  private func presentImagePickerController() {
    guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
      print("The photo library is not avail")
      return
    }
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    
    present(imagePicker, animated: true, completion: nil)
  }
  
  // process image - configure
     private func image(byFiltering inputImage: CIImage) -> UIImage {
   //    let inputImage = CIImage(image: image)
       colorControlsFilter.inputImage = inputImage
       colorControlsFilter.saturation = saturationSlider.value
       colorControlsFilter.brightness = brightnessSlider.value
       colorControlsFilter.contrast = contrastSlider.value
       
       //TODO - Add Mystery Slider Pixelate
   
       blurFilter.inputImage = colorControlsFilter.outputImage?.clampedToExtent()
       blurFilter.radius = blurSlider.value
       
       guard let outputImage = blurFilter.outputImage else { return originalImage! } // recipe for filter - not implimentation
       guard let renderedImage = context.createCGImage(outputImage, from: inputImage.extent) else { return originalImage! }
       return UIImage(cgImage: renderedImage)
     }
     
   private func presentSuccessfulSaveAlert() {
       let alert = UIAlertController(title: "Photo Saved!", message: "The photo has been saved to your Photo Library!", preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
       present(alert, animated: true, completion: nil)
   }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  //MARK: Actions
  
  @IBAction func brightnessSliderTap(_ sender: Any) {
    updateImage()
  }
  @IBAction func contrastSliderTap(_ sender: Any) {
    updateImage()
  }
  @IBAction func saturationSliderTap(_ sender: Any) {
    updateImage()
  }
  @IBAction func blurSliderTap(_ sender: Any) {
    updateImage()
  }
  @IBAction func mysterySliderTap(_ sender: Any) {
    updateImage()
  }
  @IBAction func saveBtnPressed(_ sender: Any) {
    // TODO: Save to photo library
        guard let originalImage = originalImage?.flattened,
          let ciImage = CIImage(image: originalImage) else { return }
        let processedImage = self.image(byFiltering: ciImage)
        PHPhotoLibrary.requestAuthorization { status in
          guard status == .authorized else { return }
          PHPhotoLibrary.shared().performChanges({
            PHAssetCreationRequest.creationRequestForAsset(from: processedImage)
          }) { (success, error) in
            if let error = error {
              print("Error saving photo: \(error)")
    //          NSLog("%@", error)
              return
            }
            DispatchQueue.main.async {
              self.presentSuccessfulSaveAlert()
            }
          }
          
        }
  }
  
  @IBAction func nextBtnTapped(_ sender: UIBarButtonItem) {
    performSegue(withIdentifier: "ImagesToMapSegue", sender: nil)
  }
  @IBAction func selectImageTapped(_ sender: Any) {
     presentImagePickerController()
  }
  @IBAction func selectCameraTapped(_ sender: Any) {
     presentImagePickerController()
  }
  

}


//extensions
extension ImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
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
