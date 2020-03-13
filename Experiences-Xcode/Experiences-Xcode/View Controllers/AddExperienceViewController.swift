//
//  AddExperienceViewController.swift
//  Experiences-Xcode
//
//  Created by Austin Potts on 3/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation
import Photos
import AVFoundation

class AddExperienceViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var expImage: UIImageView!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    //MARK: - Model Controllers
    let locationController = LocationController()
    
    var experienceController: ExperienceController?
    
    
    
    //MARK: - Computed Properties
    
    var videoURL: URL?
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var audioURL: URL?
    
    var isRecording: Bool {
       return audioRecorder?.isRecording ?? false
       }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    
    //MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func updateViews() {
        nextButton.isEnabled = !(titleTextField.text?.isEmpty ?? true)
            
        chooseImageButton.isHidden = expImage.image != nil
             
        recordAudioButton.isSelected = isRecording
        playAudioButton.isSelected = isPlaying
    }
    
    //MARK: - Delete Audio & Video URLs
    private func deletePreviousAudioRecording() {
             let fileManager = FileManager.default
             
             do {
                 if let recordURL = audioURL {
                     try fileManager.removeItem(at: recordURL)
                     self.audioURL = nil
                 }
             } catch {
                 NSLog("Error deleting Audio Recording: \(error)")
             }
         }
         
         private func deletePreviousVideoRecording() {
             let fileManager = FileManager.default
             
             do {
                 if let recordURL = videoURL {
                     try fileManager.removeItem(at: recordURL)
                     self.videoURL = nil
                 }
             } catch {
                 NSLog("Error deleting Video Recording: \(error)")
             }
         }
    
    
    //MARK: - Image Picker
    private func presentImagePickerController() {
          guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
          
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = .photoLibrary
          
          present(imagePicker, animated: true, completion: nil)
      }
    
    //MARK: - Record/ Play/ Toggle/ File Manager
    private func record() {
        let fileManager = FileManager.default
              
        deletePreviousAudioRecording()
              
        // Path
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
              
    
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let file = documentsDirectory
                .appendingPathComponent(name)
                .appendingPathExtension("caf") //.caf Audio File
              
        print(file)
              
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        audioURL = file
        audioRecorder?.delegate = self
        audioRecorder?.record()
        updateViews()
    }
          
          private func stopRecording() {
              audioRecorder?.stop()
              updateViews()
          }
          
          func recordToggle() {
              if isRecording {
                  stopRecording()
              } else {
                  record()
              }
          }
          
          private func play() {
              audioPlayer?.play()
              updateViews()
          }
          
          private func stopPlayback() {
              audioPlayer?.stop()
              updateViews()
          }
          
          private func playToggle() {
              if isPlaying {
                  stopPlayback()
              } else {
                  play()
              }
          }
    
    //MARK: - IBACTIONS for Add Image, Record, Play

    
    @IBAction func addImageTapped(_ sender: Any) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.presentImagePickerController()
                    }
                }
            }
        case .restricted:
            break
        case .denied:
            break
        @unknown default:
            break
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        recordToggle()
    }
    
    @IBAction func playTapped(_ sender: Any) {
        playToggle()
    }
    
    //MARK: Segue to Video
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if let cameraVC = segue.destination as? RecordVideoViewController {
                 cameraVC.experienceController = experienceController
                 cameraVC.delegate = self
             }
         }
    
    //MARK: Filter Testing
    private let monoFilter = CIFilter(name: "CIPhotoEffectMono")!
    private let context = CIContext(options: nil)
    
}


//MARK: - TextField Delegate
extension AddExperienceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        updateViews()
        
        return true
    }
}

//MARK: Location Controller Delegate
extension AddExperienceViewController: LocationControllerDelegate {
    func update(locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate,
            let title = titleTextField.text,
            !title.isEmpty else { return }
        
        var imageData: Data?
        
        if let image = expImage.image {
            imageData = image.pngData()
        }
        
        experienceController?.createExperience(title: title, coordinate: coordinate, videoURL: videoURL, audioURL: audioURL, imageData: imageData)
        
        audioURL = nil
        videoURL = nil
        
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: Image Picker Controller Delegate
extension AddExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        guard let cgImage = image.cgImage else { return }
        
        var ciImage = CIImage(cgImage: cgImage)
        
        monoFilter.setValue(ciImage, forKey: "inputImage")
        if let outputCIImage = monoFilter.outputImage {
            ciImage = outputCIImage
        }
        
        let bounds = CGRect(origin: CGPoint.zero, size: image.size)
        guard let outputCGImage = context.createCGImage(ciImage, from: bounds) else { return }
        
        expImage.image = UIImage(cgImage: outputCGImage)
        
        updateViews()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: Audio Recorder Delegate

extension AddExperienceViewController: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            NSLog("Record error: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordURL = audioURL {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recordURL)
                audioPlayer?.delegate = self
            } catch {
                NSLog("Error loading recorded audio: \(error)")
            }
        }
        updateViews()
    }
}

//MARK: Audio Player Delegate

extension AddExperienceViewController: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            NSLog("Playback error: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
}

extension AddExperienceViewController: CameraViewControllerDelegate {
    func setRecordURL(_ recordURL: URL) {
        videoURL = recordURL
        locationController.requestLocation()
    }
    
    func saveWithNoVideo() {
        deletePreviousVideoRecording()
        locationController.requestLocation()
    }
}
