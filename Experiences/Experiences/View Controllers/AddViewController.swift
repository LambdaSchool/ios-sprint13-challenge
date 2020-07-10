//
//  AddViewController.swift
//  Experiences
//
//  Created by Vincent Hoang on 7/10/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import AVFoundation

class AddViewController: UIViewController, UINavigationControllerDelegate {
    
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
    
    var audioRecording: URL? {
        didSet {
            updateAudioFile()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Utility
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    }
    
    private func stopRecording() {
        isRecording = false
        
        recordButton.setImage(UIImage(systemName: "recordingtape"), for: .normal)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        playButton.isUserInteractionEnabled = true
        
        avRecorder?.stop()
    }
    
    private func updateAudioFile() {
        do {
            avPlayer = try AVAudioPlayer(contentsOf: audioRecording!)
            avPlayer?.delegate = self
            avPlayer?.isMeteringEnabled = true
    
        } catch {
            NSLog("Unable to set audio to new instance of AVAudioPlayer")
            return
        }
    }
}
