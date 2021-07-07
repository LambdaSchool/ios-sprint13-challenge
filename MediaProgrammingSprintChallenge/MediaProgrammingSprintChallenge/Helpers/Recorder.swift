//
//  Recorder.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import AVFoundation

protocol RecorderDelegate: AnyObject {
    func recorderDidChangeState(recorder: Recorder)
}

class Recorder: NSObject {
    
    override init() {
        super.init()
    }
    
    func record() {
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        guard let url = url else { return }
        
//        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 2)!
        
        audioRecorder = try! AVAudioRecorder(url: url, settings: settings)
        
        audioRecorder?.delegate = self
        audioRecorder?.record()
        notifyDelegate()
    }
    
    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        notifyDelegate()
        hasRecorded = true
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
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    var url: URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory.appendingPathComponent("audioComment.m4a")
    }
    
    var hasRecorded: Bool = false
    
    weak var delegate: RecorderDelegate?
    
    private var audioRecorder: AVAudioRecorder?
}

extension Recorder: AVAudioRecorderDelegate {
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print(error)
        }
        notifyDelegate()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        notifyDelegate()
    }
}
