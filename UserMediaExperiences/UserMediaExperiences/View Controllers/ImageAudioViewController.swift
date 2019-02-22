//
//  ViewController.swift
//  UserMediaExperiences
//
//  Created by Austin Cole on 2/22/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class ImageAudioViewController: UIViewController, RecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    //MARK: Private Properties
    private let recorder = Recorder()
    private var originalImage: UIImage?
    
    private let filter = CIFilter(name: "CIColorControls")
    private let context = CIContext(options: nil)
    private var brightnessValue: Float = 10
    private var contrastValue: Float = 10
    private var saturationValue: Float = 10
    
    //MARK: Non-Private Properties
    var userExperienceController: UserExperienceController?
    var userExperience: UserExperience?
    //MARK: IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addPosterImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder.delegate = self
        imageView.isHidden = true
    }
    
    //MARK: IBAction
    @IBAction func nextButtonWasTapped(_ sender: Any) {
        userExperience?.title = titleTextField.text
        userExperience?.audioURL = recorder.currentFile
        let imageData = imageView.image?.pngData()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPosterImageButtonWasTapped(_ sender: Any) {
        presentImagePickerController()
    }
    
    @IBAction func recordButtonWasTapped(_ sender: Any) {
        recorder.toggleRecording()
    }
    
    //MARK: Private Methods
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)  else{
            print("photo library is unavailable")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    private func updateViews() {
        let isRecording = recorder.isRecording
        recordAudioButton.setTitle(isRecording ? "Stop Recording" : "Record", for: .normal)
    }
    
    private func applyFilter(to image: UIImage) -> UIImage {
        
        let inputImage: CIImage
        if let ciimage = image.ciImage {
            inputImage = ciimage
        } else if let cgimage = image.cgImage {
            inputImage = CIImage(cgImage: cgimage)
        } else {
            // If we get to here, we have no idea what is going on and we just return the image, because what else can we do?
            return image
        }
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        
        filter?.setValue(brightnessValue, forKey: kCIInputBrightnessKey)
        filter?.setValue(contrastValue, forKey: kCIInputContrastKey)
        filter?.setValue(saturationValue, forKey: kCIInputSaturationKey)
        
        guard let outputImage = filter?.outputImage else{
            return image
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    //MARK: RecorderDelegate
    func recorderDidChangeState(_ recorder: Recorder) {
        updateViews()
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
        imageView.image = applyFilter(to: originalImage!)
        imageView.isHidden = false
        addPosterImageButton.isHidden = true
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imageView.isHidden = false
        addPosterImageButton.isHidden = true
    }
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as? CameraViewController
            destinationVC?.userExperienceController = self.userExperienceController
        destinationVC?.userExperience = self.userExperience
        
    }


}

