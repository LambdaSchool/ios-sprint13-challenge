//
//  VideoRecordingViewController.swift
//  LambdaTimeline
//
//  Created by Nick Nguyen on 4/8/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage.CIFilterBuiltins

enum BestDevice {
    static func bestCamera(position: AVCaptureDevice.Position) -> AVCaptureDevice {
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: position) {
            return ultraWideCamera
        }
        if let wideCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
            return wideCamera
        }
             fatalError("No cameras on the device (or you're running this on a Simulator which isn't supported)")
    }
    
    
       static func bestAudio() -> AVCaptureDevice {
           if let device = AVCaptureDevice.default(for: .audio) {  return device   }
           
           fatalError("No audio")
       }
}

class CameraPreviewView: UIView {
    override class var layerClass: AnyClass {
        
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPlayerView: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get { return videoPlayerView.session }
        set { videoPlayerView.session = newValue }
    }
}


class VideoRecordingViewController: UIViewController {
  
    

    //MARK:- Properties:

    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    private var player: AVPlayer!
    
    @objc func recordTapped() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    private let videoRecordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeConfiguration = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
        button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "dot.square",withConfiguration: largeConfiguration ), for: .normal)
        button.setImage(UIImage(systemName: "stop.circle",withConfiguration: largeConfiguration), for: .selected)
        button.tintColor = .white
        return button
    }()
    
    private let cameraPreviewView : CameraPreviewView = {
       let view = CameraPreviewView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.6909318566, green: 0.7678380609, blue: 0.870224297, alpha: 1)
        return view
    }()
    
    //MARK:- Private:-
    
    private func addSwipeGestureToView() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(sender:)))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
    }
    
    private func swipeCameraPosition() {
        //Change camera source
        //Indicate that some changes will be made to the session
        captureSession.beginConfiguration()
        //Remove existing input
        guard let currentCameraInput: AVCaptureInput = captureSession.inputs.first else {  return   }
        
        //Get new input
        var newVideoInput: AVCaptureDeviceInput!
        var audioInput: AVCaptureDeviceInput!
        var newCamera: AVCaptureDevice! = nil
        
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            newCamera = (input.device.position == .back) ? BestDevice.bestCamera(position: .front) : BestDevice.bestCamera(position: .back)
        }
        //Add input to session
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            
            let microphone = BestDevice.bestAudio()
            audioInput = try AVCaptureDeviceInput(device: microphone)
        } catch let err as NSError {
            print(err.localizedDescription)
            newVideoInput = nil
        }
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {  captureSession.removeInput(input)   }
        }
        if newVideoInput == nil  {
            print("Error creating capture device input")
        } else {
            captureSession.addInput(newVideoInput)
            captureSession.addInput(audioInput)
        }
        
        captureSession.commitConfiguration()
    }
    
    private func setUpCaptureSession() {
        
        captureSession.beginConfiguration()
        let camera = BestDevice.bestCamera(position: .back)
        
        guard let captureInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(captureInput) else { fatalError("Can't create the input from the camera  ") }
        
        captureSession.addInput(captureInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
            
        }
        
        let microphone = BestDevice.bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioInput) else { fatalError("Can't create microphone input") }
        captureSession.addInput(audioInput)
        // Video
        
        // Recording to disk
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to disk")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        
        // Live preview
        cameraPreviewView.session = captureSession
    }
    
    private func playMovie(url: URL) {
        
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
    
        var topRect = view.bounds
        topRect.size.height = topRect.size.height / 4
        topRect.size.width = topRect.size.width / 4
        topRect.origin.y = view.layoutMargins.top
        
        playerLayer.frame = topRect
        view.layer.addSublayer(playerLayer)
        
        player.play()
    }
       
       private func newRecordingURL() -> URL {
           let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
           let formatter = ISO8601DateFormatter()
           formatter.formatOptions = [.withInternetDateTime]
           let name = formatter.string(from: Date())
           let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
           return fileURL
       }
       
       private func updateViews() {
             videoRecordButton.isSelected = fileOutput.isRecording
         }
       
       private func replayMovie() {
           guard let player  = player else  { return }
           
           player.seek(to: .zero)
           player.play()
       }
    //MARK:- View Life Cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraPreviewView)
        view.addSubview(videoRecordButton)
        
        setUpNavigationItem()
        cameraPreviewView.videoPlayerView.videoGravity = .resizeAspectFill
        
        setUpCaptureSession()
      
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        
        view.addGestureRecognizer(tapGesture)
          addSwipeGestureToView()
        
        setUpConstraintsForViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         captureSession.startRunning()
     }
     
     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         captureSession.stopRunning()
     }
    
    
    //MARK:- UI WORKS
    
    private func setUpConstraintsForViews() {
        
        NSLayoutConstraint.activate([
            cameraPreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraPreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraPreviewView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraPreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            videoRecordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            videoRecordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 200),
            videoRecordButton.widthAnchor.constraint(equalToConstant: 100),
            videoRecordButton.heightAnchor.constraint(equalToConstant: 100)
        
        ])
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = "New Video Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(handleDone))
    }
  //MARK:- Objc Functions
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
    
           switch tapGesture.state {
               case .ended:
              replayMovie()
                default:
               break
           }
          }
    
    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
          print(sender.direction)
          swipeCameraPosition()
      }
 
    @objc func handleDone() {
       dismiss(animated: true, completion: nil)
      
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
 
}
extension VideoRecordingViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("didFinishRecording")
        if let error = error {
            print("Video Recording Error: \(error)")
        } else {
            
          playMovie(url: outputFileURL)
        }
          updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        // Update UI
        print("didStartRecording: \(fileURL)")
        updateViews()
    }
    
    
}

