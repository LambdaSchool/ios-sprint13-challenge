//
//  VideoRecorder.swift
//  ChallengeExperience
//
//  Created by Michael Flowers on 9/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import AVFoundation
import UIKit

//create a delegate to update the Button on the view in the viewController
protocol VideoRecorderDelegate: AnyObject {
    func recorderDidChangeState(recorder: VideoRecorder)
}

class VideoRecorder: NSObject {
    
    //store a reference for the recording url
    var recordingURL: URL?
    
     lazy var captureSession = AVCaptureSession()
     lazy var movieFileOutput = AVCaptureMovieFileOutput() // this is to save the video to a file.
    weak var delegate: VideoRecorderDelegate?
    
    //get the device
     func cameraOnDevice() -> AVCaptureDevice {
        //choose the position of the camer - try our best camera first
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        
        //cant get our best camera so just get a camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back){
            return device
        }
        
        //cannot get a camera
        fatalError("You must be using a simulator or an old ass iPhone.")
    }
    
    //now that we have a device, see if we can get input from it
    
     func cameraCaptureSession(cameraPreviewView: CameraPreviewView){
        let camera = cameraOnDevice()
        
        //try to see if you can get camera input
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else { fatalError("Can't create input from camera.") }
        
        //set up inputs but first verify to see if we CAN add them and then ADD them.
        if captureSession.canAddInput(cameraInput){
            captureSession.addInput(cameraInput)
        }
        
        //set up outputs
        if captureSession.canAddOutput(movieFileOutput){
            captureSession.addOutput(movieFileOutput)
        }
        
        //you can set the quaility of the video here
        if captureSession.canSetSessionPreset(.hd1920x1080){
            captureSession.canSetSessionPreset(.hd1920x1080)
        }
        
        //commit the configurations
        captureSession.commitConfiguration()
        
        //add to the uiview
        cameraPreviewView.session = captureSession
    }
    
     func startRunning(){
        captureSession.startRunning()
    }
    
     func stopRunning(){
        captureSession.stopRunning()
    }
    
     func newRecording() -> URL? {
        //get the document directory
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { print("\(#line)--Error getting document directory."); return nil }
        
        //name the docDir
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        
        //append the name and extension
        let url = documentDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        
        //store a reference to the url
        recordingURL = url
//        print("RecordingURL: \(recordingURL)")
//        print("URL: \(url)")
        return url
    }
    
    func toggleVideoRecording(){
        if movieFileOutput.isRecording {
            movieFileOutput.stopRecording()
//            print("endRecording")
        } else {
            guard let url = newRecording() else { print("Dont have the url to start recording."); return }
            movieFileOutput.startRecording(to: url, recordingDelegate: self)
            //notify delegate in the delegate method calls
//            print("start recording")
        }
    }
    
    func notifiyDelegate(){
        delegate?.recorderDidChangeState(recorder: self)
    }
}

extension VideoRecorder: AVCaptureFileOutputRecordingDelegate {
    
    //these are not called on a specific thread so anything you do here that will affect the ui must be put back on the main thread
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
//        print("didStart was triggered")
        DispatchQueue.main.async {
            self.notifiyDelegate()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//        print("didFinish was triggered")
        DispatchQueue.main.async {
            self.notifiyDelegate()
        }
    }
}
