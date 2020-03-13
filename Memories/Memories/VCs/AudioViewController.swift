//
//  AudioViewController.swift
//  Test
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder?
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record)
        try? session.setActive(true, options: [])
    }
    
    private func newURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documents.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
        UserDefaults.standard.set(url.lastPathComponent, forKey: "CurrentAudio")
        return url
    }
    
    func startRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { bool in
                if bool { self.startRecording(); return }
            }
        case .granted:
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!
            audioRecorder = try? AVAudioRecorder(url: newURL(), format: format)
            audioRecorder?.record()
        default:
            break
        }
    }
    
    @IBAction func recordingToggled(_ sender: Any) {
        recordButton.isSelected.toggle()
        if recordButton.isSelected {
            startRecording()
        } else {
            audioRecorder?.stop()
            recordButton.isEnabled = false
            recordButton.tintColor = .green
        }
    }
    
}
