//
//  Recorder.swift
//  Experiences
//
//  Created by Ciara Beitel on 11/4/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import AVFoundation

protocol RecorderDelegate {
    func recorderDidChangeState(recorder: Recorder)
    func recorderDidSaveFile(recorder: Recorder)
}

 class Recorder: NSObject {
    
    var audioRecorder: AVAudioRecorder?
    var delegate: RecorderDelegate?
    var url: URL? {
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
        let file = documentsDirectory.appendingPathComponent(name).appendingPathExtension("caf")
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        do {
            print("record: \(file.path)")
            audioRecorder = try AVAudioRecorder(url: file, format: format)
            audioRecorder?.delegate = self
        } catch {
            print("AVAudioRecorder Error: \(error)")
        }
        audioRecorder?.record()
        delegate?.recorderDidChangeState(recorder: self)
    }
    
    func stop() {
        audioRecorder?.stop()
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
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("AVAudioRecorder Error: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        delegate?.recorderDidSaveFile(recorder: self)
    }
}
