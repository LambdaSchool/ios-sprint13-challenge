//
//  VideoRecordViewController.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoRecordViewController: UIViewController {

    // MARK: - Properties & Outlets

    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    private var player: AVPlayer?

    @IBOutlet private weak var cameraView: CameraPreviewView!
    @IBOutlet private weak var recordButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        updateViews()

        let tapToPlayGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapToPlayGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }


    // MARK: - IBAction

    @IBAction func recordButtonTapped(_ sender: UIButton) {
        record()
    }

    @IBAction func saveTapped(_ sender: UIButton) {

    }

    // MARK: - Video Control Functions

    @objc
    func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        switch tapGesture.state {
        case .began:
            print("Tapped")
        case .ended:
            replayRecording()
        default:
            break
        }
    }

    func record() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newTempURL(withFileExtension: "mov"), recordingDelegate: self)
        }
    }

    private func replayRecording() {
        if let player = player {
            player.seek(to: CMTime.zero)
            player.play()
        }
    }

    func playMovie(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        var topRect = self.view.bounds
        topRect.size.height /= 4
        topRect.size.width /= 4
        topRect.origin.y = view.layoutMargins.top

        playerLayer.frame = topRect
        view.layer.addSublayer(playerLayer)

        player?.play()
    }

    private func audio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }

    // MARK: - Setup Camera

    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("No cameras on device (or you're running in the simulator)")
        }
    }

    private func setupCamera() {
        let camera = bestCamera()

        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create an input from this camera device")
        }

        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session can't handle this type of input")
        }

        let microphone = audio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            fatalError("Can't create input from microphone")
        }

        guard captureSession.canAddInput(audioInput) else {
            fatalError("Can't add audio input")
        }

        captureSession.addInput(audioInput)
        captureSession.addInput(cameraInput)

        if captureSession.canSetSessionPreset(.hd4K3840x2160) {
            captureSession.sessionPreset = .hd4K3840x2160
        } else {
            captureSession.sessionPreset = .high
        }

        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to a movie file")
        }

        captureSession.addOutput(fileOutput)
        captureSession.commitConfiguration()

        cameraView.session = captureSession
    }


    // MARK: - Helper Functions

    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
        if recordButton.isSelected {
            recordButton.tintColor = .systemRed
        } else {
            recordButton.tintColor = .systemPink
        }
        
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
    }

    private func newTempURL(withFileExtension fileExtension: String? = nil) -> URL {
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
        let name = UUID().uuidString
        let tempFile = tempDir.appendingPathComponent(name).appendingPathExtension(fileExtension ?? "")

        return tempFile
    }
}

extension VideoRecordViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {

        DispatchQueue.main.async {
            self.updateViews()
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {

        DispatchQueue.main.async {
            self.updateViews()
            self.playMovie(url: outputFileURL)
        }
    }
}



