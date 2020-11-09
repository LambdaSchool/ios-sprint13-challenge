//
//  NewXperiencePostViewController.swift
//  11-7-20 iosLambdaExperiencesSprintChallenge
//
//  Created by BrysonSaclausa on 11/7/20.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins
import MapKit

class NewXperiencePostViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    @IBOutlet weak var slider4: UISlider!
    
    // MARK: - Properties
    var imageData: Data?
    let context = CIContext()
    let locationManager = CLLocationManager()
    
    var originalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    var scaledImage: CIImage?{
        didSet{
            updateImage()
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    private func presentImagePickerController() {
          guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
              print("The photo library is not available.")
              return
          }
          let imagePicker = UIImagePickerController()
          imagePicker.sourceType = .photoLibrary
          imagePicker.delegate = self
          present(imagePicker, animated: true, completion: nil)
      }
    
    private func updateImage() {
         if let originalImage = originalImage {
             imageView.image = originalImage
         } else {
             imageView.image = nil
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
    
    //MARK: - IBACTIONS
    
    @IBAction func chooseAnImageTapped(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func addARecordingTapped(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
}

    // MARK: - Extenstions
    extension NewXperiencePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            chooseImageButton.setTitle("", for: [])
            chooseImageButton.image(for: [])
            
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

    extension UIViewController {
    
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: completion)
    }
}
