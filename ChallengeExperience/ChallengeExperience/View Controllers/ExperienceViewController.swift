//
//  ExperienceViewController.swift
//  ChallengeExperience
//
//  Created by Michael Flowers on 9/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit
import Photos

class ExperienceViewController: UIViewController {
    
    //MARK: Properties
    var experienceController: ExperienceController? {
        didSet {
            print("ExperienceViewController: Expreience controller was set")
        }
    }
    
    var coordinate: CLLocationCoordinate2D? {
        didSet {
            print("ExperienceViewController: coordinate  was set")
        }
    }
    
    let recorder = AudioRecorder()
    var imageData: Data?
    private let filter = CIFilter(name: "CIColorControls")
    private let context = CIContext(options: nil) //this will do the rendering at the end
    
    var experienceTitle: String {
        guard let title = titleTextField.text, !title.isEmpty else { print("no title"); return ""}
        return title
    }
    var originalImage: UIImage? {
        didSet {
            //when this is set, update it to filter
            updateImage()
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPosterImageProperties: UIButton!
    @IBOutlet weak var recordProperties: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder.delegate = self
        addPosterImageProperties.isHidden = false
    }
    
    //MARK: IBActions
    @IBAction func showPhotoLibrary(_ sender: UIButton) {
        //pop up action sheet to either access the photo library or camera to take a picture
        actionSheet()
    }
    
    @IBAction func recordAudioButton(_ sender: UIButton) {
        //toggle buttonTitle record/stop recording
        recorder.toggleRecording()
    }
    
    func updatViews(){
        recordProperties.setTitle(recorder.isRecording ? "Stop Recording" : "Record", for: .normal)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        //segue to another viewcontroller that will be used to record a video
        performSegue(withIdentifier: "ToVideo", sender: nil)
    }
    
    //pass the information to VidoeViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToVideo" {
            guard let destionatVC = segue.destination as? VideoViewController, let unwrappedImageData = imageData, let unwrappedAudioURL = recorder.fileURL else { print("SEGUE didnt work"); return }
            destionatVC.imageData = unwrappedImageData
            destionatVC.audioURL = unwrappedAudioURL
            destionatVC.experienceName = experienceTitle
            destionatVC.experienceController = experienceController
            destionatVC.coordinate = coordinate
        }
    }
    
    //MARK: Class Methods
    func photoLibrarySelected(){
        //check to see if the sourceTypeIsAvailable
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { print("the Photo library is not available."); return }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func cameraSelected(){
        //check to see if the sourceTypeIsAvailable
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { print("the camera is not available."); return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func actionSheet(){
        let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.photoLibrarySelected()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.cameraSelected()
        }
        
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //filter image function
    private func image(byFiltering image: UIImage) -> UIImage {
        //CGImage -> CIImage -> CGImage -> UIImage
        guard let cgImage = image.flattened.cgImage else { return image }
        
        //create the CIImage
        let ciImage = CIImage(cgImage: cgImage)
        
        //set the filter property
        filter?.setValue(ciImage, forKey: "inputImage")
        filter?.setValue(0, forKey: kCIInputSaturationKey)
        
        //set the outputImage
        guard let outputCIImage = filter?.outputImage else { return image }
        
        //render the image/ filter the image
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    func updateImage(){
        if let originalImage = originalImage {
            imageView.image = image(byFiltering: originalImage)
            imageData = originalImage.pngData()
            addPosterImageProperties.isHidden = true
        } else {
            imageView.image = nil
            imageData = nil
            addPosterImageProperties.isHidden = false
        }
    }
}

extension ExperienceViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ExperienceViewController: AudioRecorderDelegate {
    func recorderDidChangeState(recorder: AudioRecorder) {
        updatViews()
    }
}


