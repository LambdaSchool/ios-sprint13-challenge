//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Farhan on 11/9/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class AddExperienceViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
    
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    private let filter = CIFilter(name: "CIPhotoEffectChrome")!
    private let context = CIContext(options: nil)
    
    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try? recordingSession.setMode(.spokenAudio)
            try? recordingSession.setActive(true)
            recordingSession.requestRecordPermission { (granted) in
                if granted {
                    NSLog("Allowed to record")
                }else {
                    NSLog("Not allowed to record")
                }
            }
            
            // Audio Settings
            
            settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]    }
    }
    
    // MARK: Local Methods
    
    
    @IBAction func selectPhoto(_ sender: Any) {
        
        let alertController = UIAlertController(title: "From where would you like to get an image?", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            let imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let photoLibAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.photoLibChosen()
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func photoLibChosen(){
        
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
    
    func applyChromeEffect(image: UIImage) -> UIImage? {
        
        guard let cgImage = image.cgImage else {return nil}
        
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter.outputImage else {return nil}
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {return nil}
        
        let newImage = UIImage(cgImage: outputCGImage)
        
        return newImage
        
    }
    
    private func presentImagePickerController(){
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("No PL")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        print(soundURL)
        return soundURL
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        if success {
            print(success)
        } else {
            audioRecorder = nil
            print("Somthing Went Wrong with Recording.")
        }
    }
    
    @IBAction func clickedAudioRecord(_ sender: AnyObject) {
        if audioRecorder == nil {
            self.recordButton.setTitle("Stop Recording", for: UIControl.State.normal)
            self.startRecording()
        } else {
            self.recordButton.setTitle("Record Voice", for: UIControl.State.normal)
            self.finishRecording(success: true)
        }
    }
    
    @IBAction func doPlay(_ sender: AnyObject) {
        if !audioRecorder.isRecording {
            self.audioPlayer = try! AVAudioPlayer(contentsOf: audioRecorder.url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
        }
    }
    
    // Audio Record/Play Delegates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(flag)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print(error.debugDescription)
    }
    internal func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        print(player.debugDescription)
    }
    
    
    // MARK: - Navigation
    
    @IBAction func showCamera(_ sender: Any) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .authorized:
            performSegue(withIdentifier: "ShowCamera", sender: nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted { self.performSegue(withIdentifier: "ShowCamera", sender: nil)}
            }
        case .denied:
            NSLog("VideoFilter need video capture access")
            return
        case .restricted:
            NSLog("VideoFilter need video capture access")
            return
        }
        
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let pickedImage = info[.originalImage] as? UIImage
        let imageToShow = applyChromeEffect(image: pickedImage!)
        
        imageView.image = imageToShow
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
