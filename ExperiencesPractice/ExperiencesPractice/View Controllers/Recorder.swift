//
//  Recorder.swift
//  ExperiencesPractice
//
//  Created by John Pitts on 7/12/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import AVFoundation

class Recorder: NSObject {
    
    private var audioRecorder: AVAudioRecorder?
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    var delegate: RecorderDelegate?
    var fileURL: URL?
    
    
    func toggleRecording() {
        
        if isRecording {
            stop()
        } else {
            record()
        }
    }
    
    func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        notifyDelegate()
    }
    
    func record() {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("AUDIO FILE CONTAINED HERE: \(documentDirectory)")
        
        let name = UUID().uuidString
        fileURL = documentDirectory.appendingPathComponent(name).appendingPathExtension("caf")
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)
        
        audioRecorder = try! AVAudioRecorder(url: fileURL!, format: format!)
        audioRecorder?.delegate = self
        
        audioRecorder?.record()
        notifyDelegate()
        
    }
    
    func notifyDelegate() {
        delegate?.recorderDidChangeState(recorder: self)
    }
    

}




extension Recorder: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        notifyDelegate()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error: \(String(describing: error))")
        notifyDelegate()
    }
}
