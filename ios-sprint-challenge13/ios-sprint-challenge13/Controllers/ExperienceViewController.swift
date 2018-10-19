//
//  ExperienceViewController.swift
//  ios-sprint-challenge13
//
//  Created by David Doswell on 10/19/18.
//  Copyright © 2018 David Doswell. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ExperienceViewController: UIViewController, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private var originalImage: UIImage?
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var recordLabel: UIButton!
    
    @IBOutlet weak var playLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Photo
    
    @IBAction func addPoster(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return NSLog("Photo library unavailable")
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        originalImage = info[.originalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Audio
    
    @IBAction func record(_ sender: Any) {
        let isRecording = recorder?.isRecording ?? false
        if isRecording {
            recorder?.stop()
            if let url = recorder?.url {
                player = try! AVAudioPlayer(contentsOf: url)
                player?.delegate = self
            }
        } else {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)
            recorder = try! AVAudioRecorder(url: recordingURL(), format: format!)
            recorder?.record()
        }
        updateViews()
    }
    
    @IBAction func play(_ sender: Any) {
        let isPlaying = player?.isPlaying ?? false
        if isPlaying {
            player?.pause()
            playTimeTimer = nil
        } else {
            let fileURL = Bundle.main.url(forResource: "06 Yellow Submarine", withExtension: "m4a")!
            if (player == nil) {
                player = try! AVAudioPlayer(contentsOf: fileURL)
                player?.delegate = self
            }
            player?.play()
        }
        updateViews()
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
        playTimeTimer = nil
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        let isPlaying = player?.isPlaying ?? false
        let playButtonTitle = isPlaying ? "Pause" : "Play"
        playLabel.setTitle(playButtonTitle, for: .normal)
        
        let isRecording = recorder?.isRecording ?? false
        let recordButtonTitle = isRecording ? "Stop" : "Record"
        recordLabel.setTitle(recordButtonTitle, for: .normal)
    }
    
    private var playTimeTimer: Timer? {
        willSet {
            playTimeTimer?.invalidate()
        }
    }
    
    
    @IBAction func next(_ sender: Any) {
        
//        guard let title = titleTextField.text else { return }
        
        
    }
    
    private func savePhoto() {
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: self.originalImage ?? UIImage(named: "Image")!)
            }, completionHandler: { (success, error) in
                if let error = error {
                    NSLog("Error saving photo:\(error)")
                    return
                }
                NSLog("Saving photo succeeded")
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func recordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    

}
