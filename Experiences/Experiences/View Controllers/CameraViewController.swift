//
//  CameraViewController.swift
//  Experiences
//
//  Created by Mark Poggi on 6/5/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class
CameraViewController: UIViewController {

    // MARK: - Properties

    var experienceController: ExperienceController?

    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()

    private var player: AVPlayer!
    private var playerView: VideoPlayerView!

    var coordinate: CLLocationCoordinate2D?
    var experienceTitle: String?
    var image: UIImage?
    var audio: URL?
    var video: URL?

    // MARK: - Outlets

    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!


    // MARK: - View Controller Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setUpCaptureSession()
    }

    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
         print("Play movie")
         if let player = player {
             player.seek(to: CMTime.zero)
             player.play()
         }
     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }

    private func updateViews() {
         recordButton.isSelected = fileOutput.isRecording
     }

    // MARK: - Methods

    private func setUpCaptureSession() {

        captureSession.beginConfiguration()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
           view.addGestureRecognizer(tapGesture)

        let camera = bestCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput) else {
                fatalError("Cannot create camera input, do something better than crashing?")
        }
        captureSession.addInput(cameraInput)

        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioInput) else {
                fatalError("Can't create and add input from microphone")
        }
        captureSession.addInput(audioInput)

        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }

        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot add movie recording")
        }
        captureSession.addOutput(fileOutput)

        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }

    private func bestCamera() -> AVCaptureDevice {
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return ultraWideCamera
        }

        if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return wideAngleCamera
        }

        fatalError("No camera available, are you on a simulator?") // TODO: show UI instead of a fatal error
    }

    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }

    private func toggleRecording() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
            updateViews()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
            updateViews()
        }
    }

    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }

    private func playMovie(url: URL) {
        let player = AVPlayer(url: url)

        if playerView == nil {
            // setup view
            let playerView = VideoPlayerView()
            playerView.player = player

            // customize the frame
            var frame = view.bounds
            frame.size.height = frame.size.height / 4
            frame.size.width = frame.size.width / 4
            frame.origin.y = view.layoutMargins.top

            playerView.frame = frame

            view.addSubview(playerView)
            self.playerView = playerView
        }
        player.play()
        self.player = player
    }

    // MARK: - Actions

    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecording()
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let experienceController = experienceController,
            let coordinate = coordinate,
            let title = experienceTitle,
            let image = image,
            let audio = audio,
            let video = video else { return }
        experienceController.createExperience(coordinate: coordinate, title: title, image: image, audio: audio, video: video)
        navigationController?.popToRootViewController(animated: true)
    }
}


// MARK: - Extensions

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("didStartRecording: \(fileURL)")

        updateViews()
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving movie: \(error)")
            return
        }
        print("Play movie!")

        DispatchQueue.main.async {
            self.playMovie(url: outputFileURL)
            self.video = outputFileURL
        }

        updateViews()
    }
}


