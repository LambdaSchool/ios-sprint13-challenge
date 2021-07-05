//
//  RecordViewController.swift
//  Experiences
//
//  Created by Dennis Rudolph on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    var expName: String?
    var expImage: UIImage?
    var expAudioURL: URL?
    var expVideoURL: URL?
    
    var expController: ExpController?
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }

    func toggleRecording() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
            expVideoURL = fileOutput.outputFileURL
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }

    func setUpCamera() {
        let camera = bestCamera()

        captureSession.beginConfiguration()

        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Cannot create camera input")
        }
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("Cannot add camera input to session")
        }
        captureSession.addInput(cameraInput)

        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }

        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            fatalError("Can't create input from microphone")
        }
        guard captureSession.canAddInput(audioInput) else {
            fatalError("Can't add audio input")
        }
        captureSession.addInput(audioInput)

        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Can't setup the file output for the movie")
        }
        captureSession.addOutput(fileOutput)

        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }

    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }

    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }

        fatalError("No cameras on the device. Or you are running on the Simulator (not supported)")
    }

    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }

    @IBAction func recordButtonTapped(_ sender: UIButton) {
        toggleRecording()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = expName else { return }
        
        let newExperience = Experience(name: name, image: expImage, audioURL: expAudioURL, videoURL: expVideoURL, latitude: expController?.usersLatitude ?? 0, longitude: expController?.usersLongitude ?? 0)
        print(newExperience.latitude)
        expController?.experiences.append(newExperience)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension RecordViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        print("Video: \(outputFileURL.path)")
        updateViews()
    }

    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
}
