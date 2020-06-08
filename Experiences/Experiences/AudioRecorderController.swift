//
//  AudioRecorderController.swift
//  Experiences
//
//  Created by Hunter Oppel on 6/8/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioRecorderControllerDelegate {
    func didNotRecievePermission() -> Void
}

class AudioRecorderController {
    var delegate: AudioRecorderControllerDelegate?
    
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    
    private var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
    
    private func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        return file
    }
    
    private func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need microphone access")
                    return
                }
                
                print("Recording permission has been granted!")
            }
        case .denied:
            delegate?.didNotRecievePermission()
        case .granted:
            startRecording()
        @unknown default:
            break
        }
    }
    
    private func startRecording() {
        if recordingURL == nil {
            recordingURL = createNewRecordingURL()
        }
        guard let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1),
            let recordingURL = recordingURL else { return }
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, format: audioFormat)
            audioRecorder?.record()
        } catch {
            NSLog("Error creating audio recorder: \(error)")
            return
        }
        
        self.recordingURL = recordingURL
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
    }
}
