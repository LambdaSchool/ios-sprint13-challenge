//
//  NewMemoryViewController.swift
//  Memories
//
//  Created by Samantha Gatt on 10/19/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit
import AVFoundation

class NewMemoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate {
    
    // MARK: - Properties
    
    private let filter = CIFilter(name: "CISepiaTone")!
    private let context = CIContext(options: nil)
    
    var player: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var addPhotoButton: UIButton!
    @IBOutlet private weak var recordStopButton: UIButton!
    @IBOutlet private weak var playbackButton: UIButton!
    
    
    // MARK: - Private functions
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        let isRecording = recorder?.isRecording ?? false
        let recordButtonTitle = isRecording ? "Stop" : "Record"
        recordStopButton.setTitle(recordButtonTitle, for: .normal)
        
        let isPlaying = player?.isPlaying ?? false
        let playButtonTitle = isPlaying ? "Pause" : "Play Back"
        playbackButton.setTitle(playButtonTitle, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    
    // MARK: - Actions
    
    @IBAction private func addPhoto(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func toggleRecord(_ sender: Any) {
        let isRecording = recorder?.isRecording ?? false
        if isRecording {
            recorder?.stop()
            if let url = recorder?.url {
                player = try! AVAudioPlayer(contentsOf: url)
                player?.delegate = self
            }
        } else {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)!
            recorder = try! AVAudioRecorder(url: newRecordingURL(), format: format)
            recorder?.record()
        }
        updateViews()
    }
    
    @IBAction func playBack(_ sender: Any) {
        let isPlaying = player?.isPlaying ?? false
        if isPlaying {
            player?.pause()
        } else {
            if player == nil {
                return
            }
            player?.play()
        }
        updateViews()
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[.originalImage] as? UIImage
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(1, forKey: kCIInputIntensityKey)
        
        guard let outputCIImage = filter.outputImage,
            let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return }
        
        imageView.image = UIImage(cgImage: outputCGImage)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
}
