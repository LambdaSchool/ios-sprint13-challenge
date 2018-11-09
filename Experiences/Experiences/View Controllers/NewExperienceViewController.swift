//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Ilgar Ilyasov on 11/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class NewExperienceViewController: UIViewController {

    @IBOutlet weak var experienceTitle: UITextField!
    @IBOutlet weak var experienceImage: UIImageView!
    @IBOutlet weak var addPosterImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    
    let context = CIContext(options: nil)
    let coolFilter = CIFilter(name: "CIPhotoEffectProcess")!
    
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var recordingURL: URL?
    
    var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playAudioButton.isHidden = true
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPosterImageTapped(_ sender: Any) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePicker()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                self.presentImagePicker()
            }
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
        }
        presentImagePicker()
    }
    
    
    @IBAction func recordAudioTapped(_ sender: Any) {
        requestRecordPermission()
        defer { updateAudioButtons() }
        
        guard !isRecording else {
            recorder?.stop()
            return
        }
        
        do {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
            recorder = try AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.delegate = self
            recorder?.record()
        } catch {
            NSLog("Unable to start recording: \(error.localizedDescription)")
        }
        
    }
    
    func updateAudioButtons() {
        let recordButtonTitle = isRecording ? "Stop Recording" : "Record Audio"
        recordAudioButton.setTitle(recordButtonTitle, for: .normal)
        
        let playerButtonTitle = isPlaying ? "Stop Playing" : "Play Audio"
        playAudioButton.setTitle(playerButtonTitle, for: .normal)
    }
    
    func newRecordingURL() -> URL {
        let documentsDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    @IBAction func playAudioTapped(_ sender: Any) {
        print("tapped")
        defer { updateAudioButtons() }
        
        guard !isPlaying else {
            player?.pause()
            return
        }
        
        if player != nil && !isPlaying {
            player?.play()
            return
        }
        
        guard let audioURL = recordingURL else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.delegate = self
            player?.play()
        } catch {
            NSLog("Unable to play audio: \(error.localizedDescription)")
        }
    }
    

    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "NextSegue" {
//
//        }
//    }
}

