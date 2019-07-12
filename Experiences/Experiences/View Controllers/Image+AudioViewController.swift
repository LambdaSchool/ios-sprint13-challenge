//
//  Image+AudioViewController.swift
//  Experiences
//
//  Created by Victor  on 7/12/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation
import UIKit
import Photos

class Image_AudioViewController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK: - Properties
    var experienceController: ExperienceController!
    var locationHelper = LocationHelper()
    var experience: Experience?
    var recorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    private let context = CIContext(options: nil)
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        experience = Experience()
        // Add location
        locationHelper.requestAuthorization()
        let location = locationHelper.getLocation()
        experience?.geotag = location?.coordinate
    }
    
    //Records and saves audio to experience
    @IBAction func recordAudio(_ sender: Any) {
        let isRecording = recorder?.isRecording ?? false
        if isRecording {
            recorder?.stop()
            if let url = recorder?.url {
                audioPlayer = try! AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
                play(withUrl: url)
                experience?.audioURL = url
                recorder = nil
            }
        } else {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)!
            recorder = try! AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.record()
        }
        updateViews()
    }
    
    //Adds Image to experience
    @IBAction func addImage(_ sender: Any) {
        presentImagePicker()
        addImageButton.isHidden = true
        
        if let title = titleTextField?.text {
            experience?.experienceTitle = title
        }
    }
    
    // MARK: - Private
    
    private func updateViews() {
        let isRecording = recorder?.isRecording ?? false
        let recorderLabel = isRecording ? "Recording" : "Record"
        recordAudioButton.setTitle(recorderLabel, for: .normal)
    }
    
    //Allows user to pick image
    private func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("No Photo Library available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Filter logic
    private func image(byFiltering image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter?.outputImage,
            let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
                return nil
        }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    //play and stop logic for recorder
    private func play(withUrl url: URL) {
        let isPlaying = audioPlayer?.isPlaying ?? false
        if isPlaying {
            audioPlayer?.pause()
        } else {
            if audioPlayer == nil {
                audioPlayer = try! AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
            }
            audioPlayer?.play()
        }
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("new")
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddVideo" {
            
        }
    }
    
}

extension Image_AudioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        if let filteredImage = self.image(byFiltering: image) {
            imageView?.image = filteredImage
            experience?.image = filteredImage
        } else {
            experience?.image = image
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
