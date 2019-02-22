//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import Photos

class AddExperienceViewController: ShiftableViewController, RecorderDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        recorder.delegate = self
        
        // Do any additional setup after loading the view.
    }

    
    // MARK: - Private Methods
    
    private func updateViews(){
        
        let isPlaying = player.isPlaying
        playButton.setTitle(isPlaying ? "Pause" : "Play", for: .normal)
        
        let isRecording = recorder.isRecording
        recordAudioButton.setTitle(isRecording ? "Stop" : "Record", for: .normal)
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func chooseImage() {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
            
        }
        presentImagePickerController()
    }
    
    private func applyFilter(to image: UIImage) -> UIImage {
        
        let inputImage: CIImage
        
        if let ciImage = image.ciImage {
            inputImage = ciImage
        } else if let cgImage = image.cgImage {
            inputImage = CIImage(cgImage: cgImage)
        } else {
            // 🤷‍♂️
            return image
        }
        
        let inputScale: NSNumber = 30.0
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputScale, forKey: kCIInputScaleKey)
        
        guard let outputImage = filter.outputImage else {
            return image
        }
        
        // convert to CGImage because Photos only likes images with CGImage data
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func updateImageView() {
        guard let image = originalImage else { return }
        imageView?.image = applyFilter(to: image)
    }
    
    // MARK - PlayerDelegate Methods
    func playerDidChangeState(_ player: Player) {
        updateViews()
        
    }
    
    func recorderDidChangeState(_ recorder: Recorder) {
        updateViews()
    }
    
    // MARK: - IBActions
    
    
    
    @IBAction func nextExperienceVCButtonClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func playButtonClicked(_ sender: Any) {
        player.playPause(song: recorder.currentFile)
    }
    
    @IBAction func getImageButtonClicked(_ sender: Any) {
        chooseImage()
    }
    
    @IBAction func recordAudioButtonClicked(_ sender: Any) {
        recorder.toggleRecording()
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var experienceTitleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var getImageButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    private var originalImage: UIImage? {
        didSet {
            updateImageView()
        }
    }
    private let context = CIContext(options: nil)
    private var filter = CIFilter(name: "CIPixellate")!
    private let recorder = Recorder()
    private let player = Player()
}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        getImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        originalImage = info[.originalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
