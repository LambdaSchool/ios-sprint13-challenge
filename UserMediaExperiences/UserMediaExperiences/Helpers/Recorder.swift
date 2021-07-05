//
//  Recorder.swift
//  SimpleAudioRecorder
//
//  Created by Austin Cole on 2/19/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import AVFoundation

protocol RecorderDelegate: AnyObject {
    func recorderDidChangeState(_ recorder: Recorder)
}

class Recorder: NSObject {
    
    private var audioRecorder: AVAudioRecorder?
    
    
    private(set) var currentFile: URL?
    
    weak var delegate: RecorderDelegate?
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            record()
        }
    }
    
    private func record() {
        
        let fm = FileManager.default
        let docs = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        
        let file = docs.appendingPathComponent(name).appendingPathExtension("caf")
        
        //sample rate is how many times per second is this audio data going to contain a piece of information, a standard audio recording tha tyou might find uses about 44k samples per second. Channels is mono audio versus stereo versus surround sound etc.
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        //for URL we need a way to create a new URL, we will use file manager
        audioRecorder = try! AVAudioRecorder(url: file, format: format)
        currentFile = file
        audioRecorder?.record()
        notifyDelegate()
    }
    private func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        notifyDelegate()
    }
    private func notifyDelegate() {
        delegate?.recorderDidChangeState(self)
    }
}
