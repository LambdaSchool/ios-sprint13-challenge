//
//  Recorder.swift
//  SimpleAudioRecorder
//
//  Created by Jordan Christensen on 10/30/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import AVFoundation

protocol RecorderDelegate {
    func recorderDidChangeState(_ recorder: Recorder)
    func recorderDidSaveFile(_ recorder: Recorder)
}

class Recorder: NSObject {
    
    var audioRecorder: AVAudioRecorder?
    var delegate: RecorderDelegate?
    var fileURL: URL? {
        audioRecorder?.url
    }
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    override init() {
        super.init()
        
        
    }
    
    func record() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        
        // <date>.caf
        let filename = documentsDirectory
                      .appendingPathComponent(name)
                      .appendingPathExtension("caf")
        
        // 44.1 kHz
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            print("record path: \(filename.path)")
            audioRecorder = try AVAudioRecorder(url: filename, format: format)
        } catch {
            NSLog("Recording error: \(error)")
        }
        
        audioRecorder?.record()
        delegate?.recorderDidChangeState(self)
    }
    
    func stop() {
        audioRecorder?.stop()
        delegate?.recorderDidChangeState(self)
    }
    
    func toggleRecoring() {
        if isRecording {
            stop()
        } else {
            record()
        }
    }
}

extension Recorder: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("AVAudioRecorder Error: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        delegate?.recorderDidSaveFile(self)
    }
}
