//
//  AudioCommentController.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class AudioCommentController {
    var audioRecorder: AVAudioRecorder?
    var recordingURL: URL?

    func createURL(){
        recordingURL = createNewRecordingURL()
        
    }
    
    func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(file)")
        
        return file
    }
    
    func cancelledRecording(for url: URL) {
        let fileManager = FileManager()
        do{
            try fileManager.removeItem(at: url)
        } catch {
            return
        }
    }
    
    func requestPermissionOrStartRecording() {
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
            print("Microphone access has been blocked.")
        case .granted:
            startRecording()
        @unknown default:
            break
        }
    }
    
    func startRecording() {
        let recordingURL = createNewRecordingURL()
                
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        audioRecorder = try? AVAudioRecorder(url: recordingURL, format: audioFormat)
        audioRecorder?.record()
        
        self.recordingURL = recordingURL
    }

    func stopRecording() {
        audioRecorder?.stop()
    }
}
