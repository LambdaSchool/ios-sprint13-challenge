//
//  AudioViewController.swift
//  Experiences
//
//  Created by Vici Shaweddy on 1/26/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    
    @IBOutlet weak var recordButton: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var postController: PostController?
    var recordingURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
    
    func updateViews() {
        
    }
    
    // MARK: - Recording
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    func startRecording() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        
        // always have isDirectory so it will be faster
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        recordingURL = file
        
        // standard frequency is 44100
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        self.audioRecorder = try? AVAudioRecorder(url: file, format: format)
        self.audioRecorder?.delegate = self
        self.audioRecorder?.record()
        self.updateViews()
    }
    
    func stopRecording() {
        self.audioRecorder?.stop()
        self.audioRecorder = nil
        self.updateViews()
    }

    // MARK: - Actions
    
    @IBAction func toggleRecording(_ sender: Any) {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add a Title", message: nil, preferredStyle: .alert)
        
        var titleTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type your title"
            titleTextField = textField
        }
        
        let addTitleAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            guard let title = titleTextField?.text,
                let recordingURL = self.recordingURL else { return }
            
            let post = Post(title: title, media: .audio(url: recordingURL))
            
            self.postController?.savePost(post)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addTitleAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AudioViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {}
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder Error: \(error)")
        }
    }
}
