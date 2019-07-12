//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Christopher Aronson on 7/12/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

class NewExperienceViewController: UIViewController {
    
    var experienceController: ExperienceController?
    var currentLocation: CLLocation?
    var pickedImage: UIImage?
    var recorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    var recordedURL: URL?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var experienceNameTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        if AVAudioSession.sharedInstance().recordPermission == .granted {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowVideoView" {
            guard let addVideoViewController = segue.destination as? AddVideoViewController else { return }
            addVideoViewController.recordedURL = recordedURL
            addVideoViewController.currentLocation = currentLocation
            addVideoViewController.experienceController = experienceController
            addVideoViewController.experienceName = experienceNameTextField.text
            addVideoViewController.image = pickedImage
        }
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("Unable to access photo libray")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func getFileName() -> URL {
        
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = UUID().uuidString
        
        return documentDir.appendingPathComponent(name).appendingPathExtension("m4a")
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            NSLog("User did not authorize access to the photo library")
        case .restricted:
            NSLog("User did not authorize access to the photo library")
            
        }
        presentImagePickerController()
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
        if recorder == nil {
            recordedURL = getFileName()
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 12000,
                            AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            do {
                recorder = try AVAudioRecorder(url: recordedURL!, settings: settings)
                recorder.delegate = self
                recorder.record()
                recordButton.setTitle("Stop", for: .normal)
            } catch{
                NSLog("\(error)")
            }
        } else {
            recorder.stop()
            recorder = nil
            recordButton.setTitle("Record", for: .normal)
        }
    }
}

extension NewExperienceViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        addImageButton.isHidden = true
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
        let cgImage = image.cgImage
        else { return }
        let context = CIContext(options: nil)
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter(name: "CIPhotoEffectProcess")
        filter?.setValue(ciImage, forKey: "inputImage")
        
        guard let ciOutputImage = filter?.outputImage,
        let outputCGImage = context.createCGImage(ciOutputImage, from: ciOutputImage.extent)
        else { return}
        
        let outputImage = UIImage(cgImage: outputCGImage)
        self.pickedImage = outputImage
        self.imageView.image = outputImage
    }
}

extension NewExperienceViewController: UINavigationControllerDelegate {
    
}

extension NewExperienceViewController: AVAudioRecorderDelegate {
    
}
