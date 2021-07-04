//
//  Recorder.swift
//  ChallengeExperience
//
//  Created by Michael Flowers on 7/11/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import AVFoundation

//create this delegate so that we can update the views to change the button from recording to stop recording as well as the functionality of the AVAudioRecorder
protocol AudioRecorderDelegate: AnyObject {
    func recorderDidChangeState(recorder: AudioRecorder)
}

class AudioRecorder: NSObject { //this will allow us to use delegate methods
    
    //store a refrence to the recorder
    private var recorder: AVAudioRecorder?
    //figure out how to pass the url to the experience initializer
    var fileURL: URL?
    weak var delegate: AudioRecorderDelegate? // so that we can update the views on the viewController
    
    var isRecording: Bool {
        return recorder?.isRecording ?? false //on line 13 we set it to an optional so we need to have a default value for this to work here
    }
    
    override init(){
        super.init()
    }
    
    //record something
    func record(){
        //TODO: Ask for permission to access microphone
        //set up document directory
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { print("Dont have document directory."); return }
        
        //create file name for document directory
        let fileName = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        
        //append the name
        fileURL = documentDirectory.appendingPathComponent(fileName).appendingPathExtension("caf")
        guard let url = fileURL else { print("Error unwrapping fileURL"); return }
//        print("This is the AudioURL: \(url)")
        
        //format the audio, khz and channels
        guard let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1) else { print("Error formating audio."); return }
        
        //try to initialize the recorder now, if that works, set the delegate and record.
        do {
           recorder =  try AVAudioRecorder(url: url, format: format)
            recorder?.delegate = self
            //start recording
            recorder?.record()
            notifiyDelegate()
        } catch  {
            print("Error initializing AVAudioRecorder: \(error.localizedDescription), DETAILED error: \(error)")
        }
    }
    
    //stop recording
    func stop(){
        recorder?.stop()
        recorder = nil //create a new recorder, its like erasing it so it can start over.
        notifiyDelegate()
    }
    
    func toggleRecording(){
        if isRecording {
            stop()
        } else {
            record()
        }
    }
    
    func notifiyDelegate(){
        delegate?.recorderDidChangeState(recorder: self)
    }
}
extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        notifiyDelegate()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
//        print("Error: \(String(describing: error))")
        notifiyDelegate()
    }
}
