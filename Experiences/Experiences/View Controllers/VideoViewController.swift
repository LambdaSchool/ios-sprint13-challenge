//
//  VideoViewController.swift
//  Experiences
//
//  Created by Sal B Amer on 5/15/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import MapKit
import AVKit
import AVFoundation

protocol VideoViewControllerDelegate {
  func videoButtonWasTapped()
}

class VideoViewController: UIViewController {
  
  var experienceController: ExperienceController?
  let locationManager = CLLocationManager()
  var delegate: VideoViewControllerDelegate?

 
  var player: AVPlayer!
  lazy private var captureSession = AVCaptureSession()
  lazy private var fileOutput = AVCaptureMovieFileOutput()

  //MARK: Outlets
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var cameraPreview: CameraPreviewView!
  @IBOutlet weak var recordButton: UIButton!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    captureSession.startRunning()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    captureSession.stopRunning()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    cameraPreview.videoPlayerLayer.videoGravity = .resizeAspectFill
    setupCamera()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    view.addGestureRecognizer(tapGesture)
  }
  
  private func setupCamera() {
      let camera = bestCamera()
      let microphone = bestMicrophone()
      
      captureSession.beginConfiguration() // first step
      
      guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
        preconditionFailure("Can't Create an input from the camera but we should view something better than crashing!")
      }
      
      guard let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
        preconditionFailure("Can't Create an input from the Mic but we should view something better than crashing!")
      }
      
      
      guard captureSession.canAddInput(cameraInput) else {
        preconditionFailure("This session can't handle this type of input: \(cameraInput)")
      }
      
      captureSession.addInput(cameraInput) // input finished
      
      guard captureSession.canAddInput(microphoneInput) else {
        preconditionFailure("This session can't handle this type of input: \(microphoneInput)")
      }
      
      captureSession.addInput(microphoneInput) // input finished
      
      if captureSession.canSetSessionPreset(.hd1920x1080) {
        captureSession.sessionPreset = .hd1920x1080
      }
      guard captureSession.canAddOutput(fileOutput) else {
         preconditionFailure("This session can't handle this type of output: \(fileOutput)")
      }
      captureSession.addOutput(fileOutput)
      
      captureSession.commitConfiguration() // last step for configuration ti capture
      
      cameraPreview.session = captureSession // for preview of video ( not recording )
      
    }
   
   // pick which camera is best
   private func bestCamera() -> AVCaptureDevice {
     if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
       return device
     }
     if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
       return device
     }
     preconditionFailure("No real cameras on device - Check if you are on simulator")
   }
   
   // pick which mic is best
   private func bestMicrophone() -> AVCaptureDevice {
     if let device = AVCaptureDevice.default(for: .audio) {
       return device
     }
     preconditionFailure("No real cameras on device - Check if you are on simulator")
   }
  
  func playRecording() {
    if let player = player {
      player.seek(to: CMTime.zero) // N/D, D = 600
      player.play()
    }
  }
  
  func playMovie(url: URL) {
     
     // using AV Kit == MUCH BETTER
     let playerVC = AVPlayerViewController()
     playerVC.player = AVPlayer(url: url)
     self.present(playerVC, animated: true, completion: nil)
  }

  
  private func requestPermissionAndShowCamera() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      requestVideoPermission()
    case .restricted:// parental controls preventing recordign
      preconditionFailure("Video is disabled, please review device restrictions")
    case .denied:
      preconditionFailure("Tell the user they cant use the app without permsisions via setting > Privacy > Video")
    case .authorized:
     setupCamera()
    @unknown default:
      preconditionFailure("A new status code was added")
    }
  }
  
  private func requestVideoPermission() {
     AVCaptureDevice.requestAccess(for: .video) { isGranted in
       guard isGranted else {
         preconditionFailure("UI: Tell the user to enable permissions")
       }
       DispatchQueue.main.async {
         self.setupCamera()
       }
     }
     
   }
  
  func updateViews() {
     recordButton.isSelected = fileOutput.isRecording
   }
   
  /// Creates a new file URL in the documents directory
  private func newRecordingURL() -> URL {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]

    let name = formatter.string(from: Date())
    let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
    return fileURL
  }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
  
  
  func postVideo() {
    view.endEditing(true)
    guard let title = titleTextField.text,
      !title.isEmpty else {
        presentInformationalAlertController(title: "Error", message: "Please Make sure that you add a caption before posting.")
        return
    }
    
  }
  
  //MARK: Actions
  
  @IBAction func cancelBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func saveBtnWasPressed(_ sender: Any) {
    postVideo()
  }
  
  @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
     if sender.state == .ended {
       playRecording()
     }
   }
  
  @IBAction func recordBtnPressed(_ sender: Any) {
    if fileOutput.isRecording {
            fileOutput.stopRecording()
          } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
          }
  }
  
}


extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
  
  func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
    updateViews()
  }
  
  func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    if let error = error {
      print("Error saving video: \(error)")
    }
    print("Video URL: \(outputFileURL)")
    updateViews()
    playMovie(url: outputFileURL)
  }
  
}
