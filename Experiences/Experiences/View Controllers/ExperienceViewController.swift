//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Linh Bouniol on 10/19/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import AVFoundation

class ExperienceViewController: UIViewController, AVAudioPlayerDelegate {
    
    var experienceController: ExperienceController!
    
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    
    // properties to store the urls so they can be saved to CoreData
    var audioURL: URL?
    var imageURL: URL?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var audioRecordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playAudioButton: UIButton!
    
    @IBAction func recordAudio(_ sender: Any) {
        let isRecording = recorder?.isRecording ?? false
        if isRecording {
            // already recording
            recorder?.stop()
            
            // after recording, create a player with the url
            if let url = recorder?.url {
                player = try! AVAudioPlayer(contentsOf: url)
                player?.delegate = self
            }
        } else {
            // start recording (always create a new recording)
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)!
            audioURL = newRecordingURL()
            recorder = try! AVAudioRecorder(url: audioURL!, format: format)
            recorder?.record()
        }
        updateViews()
    }
    
    @IBAction func playAudio(_ sender: Any) {
        let isPlaying = player?.isPlaying ?? false
        
        if isPlaying {
            // Already playing, so stop playback
            player?.pause()
        } else {
            
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playAndRecord, mode: .default, options: [])
                try session.overrideOutputAudioPort(.speaker)
                try session.setActive(true, options: []) // session is acive whenever the app starts up
            } catch {
                NSLog("Error setting up audio session: \(error)")
            }
            
            player?.play()
        }
        updateViews()
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        presentImagePickerController()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        // if player is playing => true, if player not playing => false, if player is nil => false
        let isPlaying = player?.isPlaying ?? false
        let playButtonTitle = isPlaying ? "Pause" : "Play"
        playAudioButton.setTitle(playButtonTitle, for: .normal)
        
        let isRecording = recorder?.isRecording ?? false
        let recordButtonTitle = isRecording ? "Stop" : "Record Audio"
        audioRecordButton.setTitle(recordButtonTitle, for: .normal)
        
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    private func newImageURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpeg")
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let videoVC = segue.destination as? VideoViewController {
            videoVC.experienceController = experienceController
            videoVC.experienceTitle = textField.text
            videoVC.audioURL = audioURL
            videoVC.imageURL = imageURL
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
   
}

extension ExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        do {
            imageURL = newImageURL()
            try chosenImage.jpegData(compressionQuality: 0.9)?.write(to: imageURL!)
        } catch {
            NSLog("Error saving image to url: \(error)")
        }
        
        imageView.image = chosenImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
