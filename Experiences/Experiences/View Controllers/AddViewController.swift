//
//  AddViewController.swift
//  Experiences
//
//  Created by Vincent Hoang on 7/10/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class AddViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Interface Builder
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var image: UIImageView!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var audioTrack: UISlider!
    
    // MARK: - Properties
    var experience: Experience?
    
    var avPlayer: AVAudioPlayer?
    var avRecorder: AVAudioRecorder?
    
    var isRecording: Bool = false
    var isPlayback: Bool = false
    
    var permissionsGranted: Bool = false
    
    var audioRecording: URL?
    
    var locationController: LocationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        
        audioTrack.setValue(0, animated: false)
        
        if let _ = experience {
            audioTrack.isUserInteractionEnabled = true
        } else {
            audioTrack.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - IBActions
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if !isRecording {
            if !isPlayback {
                play()
            } else {
                pause()
            }
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if !isPlayback {
            if !isRecording {
                startRecording()
            } else {
                stopRecording()
            }
        }
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        titleTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Utility
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            NSLog("Button identifier mismatch")
            return
        }
        
        guard let title = titleTextField.text else {
            present(alertBuilder(message: "Title field must not be empty"), animated: true, completion: nil)
            return
        }
        
        guard let coordinate = locationController?.getLocation() else {
            NSLog("Coordinates not available")
            return
        }
        
        let newExperience = Experience(title: title, image: image.image?.pngData(), audioRecording: audioRecording, coordinate: coordinate.coordinate)
        
        experience = newExperience
    }
    
    // MARK: - Location
    

}

extension AddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        let filteredImage = Filters.posterize(inputImage: CIImage(data: selectedImage.pngData()!)!)
        
        image.image = UIImage(ciImage: filteredImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    //MARK: - AVPlayer
    private func setUpAVRecorder() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    private func play() {
        if let _ = avPlayer {
            avPlayer?.play()
        
            isPlayback = true
        
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            recordButton.isUserInteractionEnabled = false
        }
    }
    
    private func pause() {
        if let _ = avPlayer {
            avPlayer?.pause()
        
            isPlayback = false
        
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            recordButton.isUserInteractionEnabled = true
        }
    }
    
    private func startRecording() {
        if permissionsGranted {
            isRecording = true
            
            recordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            playButton.setImage(UIImage(systemName: "play"), for: .normal)
            
            playButton.isUserInteractionEnabled = false
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirectory.appendingPathComponent(DateFormatter.localizedString(
                from: Date(),
                dateStyle: .long,
                timeStyle: .long),
                                                                  isDirectory: false).appendingPathExtension("caf")
            
            let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
            
            do {
                avRecorder = try AVAudioRecorder(url: url, format: audioFormat)
            } catch {
                NSLog("Unable to start recording")
                return
            }
            
            avRecorder?.delegate = self
            avRecorder?.isMeteringEnabled = true
            
            avRecorder?.record()
            
            audioRecording = url

        } else {
            getPermissionAudioRecording()
        }
    }
    
    private func stopRecording() {
        isRecording = false
        
        recordButton.setImage(UIImage(systemName: "recordingtape"), for: .normal)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        playButton.isUserInteractionEnabled = true
        audioTrack.isUserInteractionEnabled = true
        
        avRecorder?.stop()
    }
    
    private func updateAudioFile() {
        do {
            avPlayer = try AVAudioPlayer(contentsOf: audioRecording!)
            avPlayer?.delegate = self
            avPlayer?.isMeteringEnabled = true
            
//            let displayLink = CADisplayLink(target: self, selector: #selector(updateSlider))
//            displayLink.add(to: .current, forMode: .common)
        } catch {
            NSLog("Unable to set audio to new instance of AVAudioPlayer")
            return
        }
    }
    
    @objc func updateSlider() {
        updateAudioTrack()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateAudioTrack()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            updateAudioFile()
        }
    }
    
    private func updateAudioTrack() {
        let duration = Float(avPlayer?.duration ?? 0.0)
        let current = Float(avPlayer?.currentTime ?? 0.0)
        
        audioTrack.maximumValue = duration
        audioTrack.maximumValue = 0.0
        audioTrack.value = current
        
    }
    
    func getPermissionAudioRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    self.present(self.alertBuilder(message: "Unable to access microphone"), animated: true, completion: nil)
                    return
                }
            }
            
        case .denied:
            present(alertBuilder(message: "Microphone access was denied"), animated: true, completion: nil)
            
        case .granted:
            permissionsGranted = true
            startRecording()
            
        @unknown default:
            NSLog("Unknown error occured while getting audio recording permissions")
            return
        }
    }
    
    func alertBuilder(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    
        return alert
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        avPlayer?.currentTime = TimeInterval(audioTrack.value)
        updateAudioTrack()
    }
}
