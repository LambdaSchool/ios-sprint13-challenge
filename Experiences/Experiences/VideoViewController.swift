//
//  VideoViewController.swift
//  Experiences
//
//  Created by brian vilchez on 2/15/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class VideoViewController: UIViewController {

    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var experienceController: ExperienceController?
    let locationManager = CLLocationManager()
      private var player: AVPlayer!
      
      @IBOutlet var recordButton: UIButton!
      @IBOutlet var cameraView: CameraView!


      override func viewDidLoad() {
          super.viewDidLoad()
          cameraView.videoPlayerView.videoGravity = .resizeAspectFill
          setUpCamera()
          
      }
      
      override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          
          captureSession.startRunning()
      }

      override func viewDidDisappear(_ animated: Bool) {
          super.viewDidDisappear(animated)
          
          captureSession.stopRunning()
      }

      private func setUpCamera() {
          let camera = bestCamera()
          captureSession.beginConfiguration()
          guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
              fatalError("Device configured incorrectly")
          }
          
          guard captureSession.canAddInput(cameraInput) else {
              fatalError("Unable to add camera input") // Programmer did something wrong ...
          }
          captureSession.addInput(cameraInput)
          
          // 1920x1080p
          if captureSession.canSetSessionPreset(.hd1920x1080) {
              captureSession.sessionPreset = .hd1920x1080
          }
          
          // Microphone
          let microphone = bestAudio()
          guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
              fatalError("Can't create input from microphone")
          }
          guard captureSession.canAddInput(audioInput) else {
              fatalError("Can't add audio input")
          }
          captureSession.addInput(audioInput)
          
          // Outputs
          guard captureSession.canAddOutput(fileOutput) else {
              fatalError("Cannot add file output")
          }
          captureSession.addOutput(fileOutput)
          
          // commit configuration
          captureSession.commitConfiguration()
          
          cameraView.session = captureSession
      }

      private func bestCamera() -> AVCaptureDevice {
          if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
              return device
          }
          if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
              return device
          }
          
          fatalError("No cameras detected")
      }
      
      private func bestAudio() -> AVCaptureDevice {
          if let device = AVCaptureDevice.default(for: .audio) {
              return device
          }
          fatalError("No audio")
      }

      @IBAction func recordButtonPressed(_ sender: Any) {
          toggleRecord()
      }

      var isRecording: Bool {
          fileOutput.isRecording
      }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
      func toggleRecord() {
          // What should I do to start/stop recording?
          if isRecording {
              fileOutput.stopRecording()
            recordButton.setImage(UIImage(named: "Record"), for: .normal)
          } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
            recordButton.setImage(UIImage(named: "Stop"), for: .normal)
          }
      }
      
      
      /// Creates a new file URL in the documents directory
      private func newRecordingURL() -> URL {
          let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

          let formatter = ISO8601DateFormatter()
          formatter.formatOptions = [.withInternetDateTime]

          let name = formatter.string(from: Date())
          let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
         let location = locationManager.location?.coordinate
         experienceController?.createExperience(withTitle: "movie", image: nil, audioRecording: nil, videoRecording: fileURL, location: location)
          return fileURL
      }
      
      private func updateViews() {
          recordButton.isSelected = isRecording
      }

}

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
        updateViews()
    }
    
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving recording: \(error)")
        }
        print("Url: \(outputFileURL.path)")
        updateViews()
        
    }
}
