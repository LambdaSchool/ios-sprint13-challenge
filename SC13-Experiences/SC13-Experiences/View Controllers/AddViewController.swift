//
//  AddViewController.swift
//  SC13-Experiences
//
//  Created by Andrew Dhan on 10/19/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit
import Photos
import CoreImage

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - IBActions
    
    @IBAction func save(_ sender: Any) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {
                NSLog("Access not permitted")
                return
            }
            
        }
    }
    @IBAction func addImage(_ sender: Any) {
        choosePhoto()
    }
    // MARK: - Methods for Image Features
    func choosePhoto(){
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is unavailable")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func applyFilter(){
        guard let originalImage = originalImage,
            let cgImage = originalImage.cgImage  else {return}
        
        let ciImage = CIImage(cgImage: cgImage)
        imageFilter.setValue(ciImage, forKey: "inputImage")
        
        guard let outputCIimage = imageFilter.outputImage,
            let outputCGImage = context.createCGImage(outputCIimage, from: outputCIimage.extent) else {return}
        let finalOutput = UIImage(cgImage: outputCGImage)
        imageView.image = finalOutput
        
    }
    
    //MARK: - UIImagePickerControllerDelegate Mehods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
    }
    @IBAction func recordVideo(_ sender: Any) {
    }
    //MARK: - Properties
    var experienceController: ExperienceController?
    
    //MARK: -Image Adding Properties
    private var originalImage: UIImage?{
        didSet{
            applyFilter()
        }
    }
    private let imageFilter = CIFilter(name: "CIPhotoEffectFade")!
    private let context = CIContext(options: nil)
    
    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordVideoButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
}
