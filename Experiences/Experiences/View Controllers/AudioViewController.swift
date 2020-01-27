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
        self.updateViews()
    }
    
    func stopRecording() {

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
                
                var commentTextField: UITextField?
                
                alert.addTextField { (textField) in
                    textField.placeholder = "Type your title"
                    commentTextField = textField
                }
                
                let addTitleAction = UIAlertAction(title: "Save", style: .default) { (_) in
                    
                    guard let commentText = commentTextField?.text else { return }
                    
        //            self.postController.addComment(with: .text(commentText), to: self.post!)
                    
                    DispatchQueue.main.async {
        //                self.tableView.reloadData()
                    }
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
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if let recordingURL = recordingURL {
//            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
//
//            // once it's saved, reset it
//            self.recordingURL = nil
//            self.updateViews()
//        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder Error: \(error)")
        }
    }
}
