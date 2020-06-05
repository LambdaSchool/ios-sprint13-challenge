//
//  Recorder.swift
//  SimpleAudioRecorder
//
//  Created by Joshua Sharp on 10/29/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import AVFoundation

protocol RecorderDelegate {
    func recorderDidChangeState(recorder: Recorder)
    func recorderDidSaveFile(recorder: Recorder)
}

class Recorder: NSObject {
    var audioRecorder: AVAudioRecorder?
    var delegate: RecorderDelegate?
    var fileURL: URL? {
        return audioRecorder?.url
    }
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
//    init(with delegate: RecorderDelegate) {
//        self.delegate = delegate
//    }
    //record
    func record() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let file = documentsDirectory.appendingPathComponent(name).appendingPathExtension("caf")
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        do {
            print ("record path: \(file)")
            audioRecorder = try AVAudioRecorder(url: file, format: format)
            audioRecorder?.delegate = self
        } catch {
            NSLog("Creating recording failed: \(error)")
        }
        audioRecorder?.record()
        delegate?.recorderDidChangeState(recorder: self)
    }
    
    //stop
    func stop () {
        audioRecorder?.stop()
        delegate?.recorderDidChangeState(recorder: self)
    }
    
    func toggleRecording () {
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
            print ("Error encoding recording: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        delegate?.recorderDidSaveFile(recorder: self)
    }
}
