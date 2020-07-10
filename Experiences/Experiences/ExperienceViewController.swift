//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Nonye on 7/10/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ExperienceViewController: UIViewController {
    
    var experienceController: ExperienceController?
    var delegate: MapViewController?
    private var inited = false
    var scaledImage: UIImage?
    private var audioClip: URL?
    private var audioRecorder: AVAudioRecorder?
    private var player: AVPlayer!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet var audioRecordButton: UIButton!
    @IBOutlet weak var brightnessFilterSlider: UISlider!
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
//            audioPlayer.isMeteringEnabled = true
        }
    }

    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    private func imageUpdateViews() {
        if let scaledImage = scaledImage {
            imageView.image = filterImage(scaledImage)
        } else {
            imageView.image = nil
        }
        
    }
    
    private func filterImage(_ image: UIImage) -> UIImage? {
        
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)

        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        guard let outputCIImage = filter.outputImage else { return nil }

        guard let outputCGImage = context.createCGImage(outputCIImage,
                                                        from: CGRect(origin: .zero, size: image.size)) else {
                                                            return nil
        }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    lazy private var captureSession = AVCaptureSession()
 
    let context = CIContext(options: nil)
    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale  // Size of pixels on this device: 1x, 2x, or 3x
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let experience = experience,
            !inited else { return }
        
        inited.toggle()
        titleTextField.text = experience.title
        originalImage = experience.image
        audioClip = experience.audioClip
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        //        audioUpdateViews()
        imageUpdateViews()
        audioRecordButton.isEnabled = !isPlaying
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let experienceController = experienceController,
            let delegate = delegate,
            let orginalImage = originalImage,
            let title = titleTextField.text else { return }
        
            let filteredImage = image(byFiltering: orginalImage)
  
            PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {
                NSLog("The user has not authorized permission for Photo Library Usage")
                       return
                   }
                   
                   PHPhotoLibrary.shared().performChanges({
                       PHAssetCreationRequest.creationRequestForAsset(from: filteredImage)
                       
                   }) { (success, error) in
                       if let error = error {
                           NSLog("Error saving photo asset: \(error)")
                           return
                       }
                       
                   }
               }
//        guard let experienceController = experienceController,
//            let delegate = delegate,
//            let title = titleTextField.text,
//            title.count > 0 else {
//                return
//        }
        let coordinates = delegate.myLocation()
        
        if let experience = experience {
            experienceController.createExperience(title: title,
                                         audioClip: audioClip,
                                         image: imageView.image,
                                         latitude: coordinates.latitude,
                                         longitude: coordinates.longitude)
        }
        
    }
}

extension ExperienceViewController {
    
    @IBAction func audioRecordButton(_ sender: Any) {
        if (audioClip == nil || (audioRecorder?.isRecording ?? false)) {
            if audioRecorder?.isRecording ?? false {
                audioStop()
            } else {
                requestPermissionOrStartRecording()
            }
        } else {
            if (audioPlayer?.isPlaying ?? false) == false {
                audioPlay()
            } else {
                audioPlayer?.stop()
                updateViews()
            }
        }
    }
    
    @IBAction func audioCancelButton(_ sender: Any) {
        audioRecorder?.stop()
        let success = audioRecorder?.deleteRecording()
        if let success = success {
            if success {
                print("Recording Canceled")
            } else {
                print("Failed to Cancel Recording.")
            }
        } else {
            print("Unabled to Cancel Recording.")
        }
        
        audioPlayer?.stop()
        audioClip = nil
        updateViews()
    }
    
    // MARK: - Private
    private func audioStop() {
        audioRecorder?.stop()
        updateViews()
    }
    
    #warning("Mic")
// todo, figure out mic fill button
    
    private func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    private func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        return file
    }
    
    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need microphone access")
                    return
                }
                
                NSLog("Recording permission has been granted")
            }
        case .denied:
           
            let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Go to Settings", style: .default) { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        case .granted:
            startRecording()
        @unknown default:
            break
        }
    }
    
    private func audioPlay() {
        guard let audioClip = audioClip else { return }
        if audioPlayer == nil {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioClip)
            } catch {
                print("Couldn't load clip; we tried: \(audioClip.absoluteString)")
                return
            }
        }
        audioPlayer?.play()
        updateViews()
    }
    
    func startRecording() {
        do {
            try prepareAudioSession()
        } catch {
            fatalError("Failed prepareAudioSession")
        }
        
        audioClip = createNewRecordingURL()
        
        guard let recordingURL = audioClip else { return }
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try? AVAudioRecorder(url: recordingURL, format: format)
        audioRecorder?.delegate = self
        audioRecorder?.record()
        
        updateViews()
    }
}

// MARK: - EXTENSION AUDIO

extension ExperienceViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag,
            let audioClip = audioClip {
            let playbackAudioPlayer = try? AVAudioPlayer(contentsOf: audioClip) // TODO: Error handling
            if let _ = playbackAudioPlayer {
                print("Saved recording to \(audioClip)")
            } else {
                print("Nothing to playback")
            }
            audioRecorder = nil
        }
        updateViews()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Record Error: \(error)")
        }
        updateViews()
    }
}

extension ExperienceViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player Error: \(error)")
        }
        updateViews()
    }
}

// MARK: - IMAGE EXTENSION

extension ExperienceViewController {
    
    
    // MARK: - ACTIONS
    
    @IBAction func addButton(_ sender: Any) {
        presentImagePickerControllerToUser()
    }
    @IBAction func brightnessSlider(_ sender: UISlider) {
        updateViews()
        updateImage()
    }
    
 private func updateImage() {
     if let scaledImage = scaledImage {
         imageView.image = image(byFiltering: scaledImage)
     } else {
         imageView.image = nil
     }
 }
 
    private func image(byFiltering image: UIImage) -> UIImage {
        //UIImage -> CGImage -> CIImage "recipe"
        guard let cgImage = image.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter.colorControls()
        
        filter.inputImage = ciImage
//        filter.brightness = brightnessSlider.value
        
        let filter2 = CIFilter(name: "CIColorControls")!
        filter2.setValue(ciImage, forKey: "inputImage")
        
//        filter2.setValue(brightnessSlider.value, forKey: "inputBrightness")
        
        guard let outputImage = filter.outputImage else {
            return image
        }
        
        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
           }
           return UIImage(cgImage: outputCGImage)
       }
       
    
    private func presentImagePickerControllerToUser() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is not available now")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ExperienceViewController: UIImagePickerControllerDelegate {
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

extension ExperienceViewController: UINavigationControllerDelegate {
    
}
