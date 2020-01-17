//
//  VideoViewController.swift
//  LambdaTimeline
//
//  Created by Jon Bash on 2020-01-15.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoRecorderDelegate: AnyObject {
    func videoRecorderDidFinishRecording(withData videoData: Data?)
    func videoRecorderDidDeleteRecording()
}

class VideoViewController: UIViewController {

    // MARK: - Properties

    private lazy var captureSession = AVCaptureSession()
    private lazy var fileOutput = AVCaptureMovieFileOutput()

    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var videoView: VideoPlayerView!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteView: UIView!

    private(set) var videoURL: URL? {
        didSet {
            if let url = videoURL {
                videoView.loadVideo(url: url)
            } else {
                videoView.unloadVideo()
            }
        }
    }
    var videoData: Data? {
        guard let url = videoURL else { return nil }
        return try? Data(contentsOf: url)
    }

    var hasVideoData: Bool { videoData != nil }

    weak var delegate: VideoRecorderDelegate?

    private var bestCamera: AVCaptureDevice {
        if #available(iOS 13.0, *),
            let device = AVCaptureDevice.default(
                .builtInUltraWideCamera,
                for: .video,
                position: .back)
        {
            return device
        }
        // fallback camera
        if let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back)
        {
            return device
        }

        fatalError("No cameras on the device, or you are running on the simulator (not supported)")
    }
    private var bestAudio: AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("mic is borked!")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Resize camera preview to fill the entire screen
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

    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording

        cameraView.isHidden = hasVideoData
        recordButton.isHidden = hasVideoData

        deleteView.isHidden = !hasVideoData
        deleteView.isHidden = !hasVideoData
        videoView.isHidden = !hasVideoData
    }

    // MARK: - Actions

    @IBAction
    private func recordButtonPressed(_ sender: Any) {
        toggleRecording()
    }

    @IBAction func removeButtonTapped(_ sender: Any) {
        trashRecording()
    }

    func toggleRecording() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(
                to: .newLocalVideoURL(),
                recordingDelegate: self)
        }
    }

    func trashRecording() {
        guard let url = videoURL else { return }
        videoURL = nil
        let fm = FileManager.default
        if fm.isDeletableFile(atPath: url.path) {
            try? fm.trashItem(at: url, resultingItemURL: nil)
        }
        delegate?.videoRecorderDidDeleteRecording()
    }

    // MARK: - Helper Methods

    private func setUpCamera() {
        // get the best camera
        let camera = bestCamera

        captureSession.beginConfiguration()

        // make changes to the devices connected
        //  - video input
        guard
            let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput)
            else { fatalError("Camera is borked?") }
        captureSession.addInput(cameraInput)

        let sessionPreset: AVCaptureSession.Preset = .hd1920x1080
        if captureSession.canSetSessionPreset(sessionPreset) {
            captureSession.sessionPreset = sessionPreset
        }

        // - audio input
        let mic = bestAudio
        guard
            let audioInput = try? AVCaptureDeviceInput(device: mic),
            captureSession.canAddInput(audioInput)
            else {
                fatalError("can't add mic device!")
        }
        captureSession.addInput(audioInput)

        // - video output (movie recording)
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("can't set up the file output for movie")
        }
        captureSession.addOutput(fileOutput)

        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
}

// MARK: - Recording Delegate

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(
        _ output: AVCaptureFileOutput,
        didStartRecordingTo fileURL: URL,
        from connections: [AVCaptureConnection]
    ) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }

    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        if let error = error {
            print("Error with video recording: \(error)")
            return
        }
        print("finished recording video: \(outputFileURL.path)")
        self.videoURL = outputFileURL
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
}
