//
//  Recorder.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_34 on 3/29/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

import AVFoundation

protocol RecorderDelegate: AnyObject {
    func recorderDidChangeState(recorder: Recorder)
}

class Recorder: NSObject {
    
    //MARK: - Properties
    // isRecording
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    var fileURL: URL?
    weak var delegate: RecorderDelegate?
    private var audioRecorder: AVAudioRecorder?
    
    override init() {
        super.init()
    }
    
    // Create a recorder
    func record() {
        
        // Documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Create a file with time stamp
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        
        // filename.caf
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("caf")
        print("file: \(fileURL.path)")
        
        // 44.1 kHz
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100.0, channels: 2)!
        
        audioRecorder = try! AVAudioRecorder(url: fileURL, format: format)
        audioRecorder?.delegate = self
        
        // start recording
        audioRecorder?.record()
        notifyDelegate()
    }
    
    // stop (save the file)
    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        notifyDelegate()
    }
    
    func toggleRecording() {
        if isRecording {
            stop()
        } else {
            record()
        }
    }
    
    private func notifyDelegate() {
        delegate?.recorderDidChangeState(recorder: self)
    }
    
}

extension Recorder: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("audioRecorderEncodeErrorDidOccur: \(error)")
        }
        notifyDelegate()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        notifyDelegate()
    }
}
