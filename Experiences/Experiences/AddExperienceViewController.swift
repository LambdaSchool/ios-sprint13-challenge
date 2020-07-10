//
//  AddExperienceViewController.swift
//  Experiences
//
//  Created by Dahna on 7/10/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import MapKit

class AddExperienceViewController: UIViewController {
    
    // MARK: Properties
    
    private let context = CIContext(options: nil)
    
    weak var timer: Timer?
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var recordButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        presentImagePicker()
    }
    
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        
        if isRecording {
            recordButton.setTitle("Stop Recording", for: .normal)
        } else {
            recordButton.setTitle("Record", for: .normal)
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
    
    // MARK: Image
    
    func image(byFiltering image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image}
        
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.photoEffectNoir()
        
        filter.inputImage = ciImage
        
        guard let outputImage = filter.outputImage else { return image }
        
        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        
        return UIImage(cgImage: outputCGImage)
    }
    
    
    
    func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Recording
    
    // func createNewRecordingURL(with Name: String) -> URL {
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(file)")
        
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
                
                print("Recording permission has been granted!")
                // NOTE: Invite the user to tap record again, since we just interrupted them, and they may not have been ready to record
            }
        case .denied:
            print("Microphone access has been blocked.")
            
            let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
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
    
    
    func startRecording() {
        // Grab the recording URL
        recordingURL = createNewRecordingURL()
        
        // Check for permission
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            guard granted else {
                NSLog("We need permission to access the microphone")
                return
            }
            
            // Set up the recorder (give it the settings we want, etc.)
            guard let recordingURL = self.recordingURL else {
                NSLog("No recording URL available")
                return
            }
            
            let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
            
            do {
                self.audioRecorder = try AVAudioRecorder(url: recordingURL, format: format)
                // Start recording
                self.audioRecorder?.delegate = self
                self.audioRecorder?.isMeteringEnabled = true
                self.audioRecorder?.record()
                self.updateViews()
            } catch {
                NSLog("Error setting up audio recorder: \(error)")
            }
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        self.updateViews()
    }
}

extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let viewImage = info[.originalImage] as? UIImage else { return }
        
        imageView.image = image(byFiltering: viewImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddExperienceViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
            self.audioRecorder?.delegate = self
            self.recordingURL = nil
            updateViews()
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            NSLog("Error recording audio: \(error)")
        }
    }
}

extension AddExperienceViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            NSLog("Error playing audio: \(error)")
        }
    }
}
