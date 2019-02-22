//
//  AudioRecorder.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioRecorderDelegate: AnyObject {
    func recorderDidChangeState(_ recorder: AudioRecorder)
}

class AudioRecorder: NSObject {
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private(set) var currentFile: URL?
    
    weak var delegate: AudioRecorderDelegate?
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    var recordingLength: TimeInterval {
        return audioRecorder?.currentTime ?? 0
    }
    
    func toggleRecording() {
        if isRecording {
            stop()
        } else {
            record()
        }
    }
    
    func record() {
        let documentDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let fileURL = documentDir.appendingPathComponent(name).appendingPathExtension(".caf")
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        audioRecorder = try! AVAudioRecorder(url: fileURL, format: format)
        currentFile = fileURL
        
        audioRecorder?.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.notifyDelegate()
        }
        notifyDelegate()
    }
    
    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        timer?.invalidate()
        timer = nil
        notifyDelegate()
    }
    
    private func notifyDelegate() {
        delegate?.recorderDidChangeState(self)
    }
    
}
