//
//  Recorder.swift
//  Experiences
//
//  Created by Thomas Cacciatore on 7/12/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import AVFoundation

protocol RecorderDelegate {
    func recorderDidChangeState(recorder: Recorder)
}
class Recorder: NSObject {
    
    private var audioRecorder: AVAudioRecorder?
    var delegate: RecorderDelegate?
    var fileURL: URL?
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    override init() {
        super.init()
    }
    
    func record() {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("doc: \(documentDirectory)")
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let fileURL = documentDirectory.appendingPathComponent(name).appendingPathExtension("caf")
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        audioRecorder = try! AVAudioRecorder(url: fileURL, format: format)
        audioRecorder?.delegate = self
        
        audioRecorder?.record()
        
        notifyDelegate()
    }
    
    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        notifyDelegate()
    }
    
    func notifyDelegate() {
        delegate?.recorderDidChangeState(recorder: self)
    }
    
    func toggleRecording() {
        if isRecording {
            stop()
        } else {
            record()
        }
    }
    
}

extension Recorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        notifyDelegate()
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error: \(error)")
        notifyDelegate()
    }
}
