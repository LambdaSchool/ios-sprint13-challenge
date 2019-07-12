//
//  Recorder.swift
//  ExperiencesPractice
//
//  Created by John Pitts on 7/12/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation
import AVFoundation

class Recorder {
    
    private var audioRecorder: AVAudioRecorder?
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    
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
        
    }
    
    func record() {
        
        audioRecorder?.record()
        
    }
    
    
    
    
    
    
    
}
