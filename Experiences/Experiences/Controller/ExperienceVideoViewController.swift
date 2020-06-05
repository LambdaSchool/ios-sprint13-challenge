//
//  ExperienceVideoViewController.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import AVFoundation
import UIKit

class ExperienceVideoViewController: UIViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var experience: Experience?
    let videoRecordingManager = VideoRecordingManager()
    private lazy var captureSession = AVCaptureSession()
    private lazy var fileOutput = AVCaptureMovieFileOutput()
    private var videoURL: URL?
    var isRecording: Bool {
        fileOutput.isRecording
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Objects
    let cameraView: CameraPreviewView = {
        let cameraView = CameraPreviewView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.backgroundColor = .systemBlue
        return cameraView
    }()
    
    let recordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
        button.tintColor = .systemRed
        button.setPreferredSymbolConfiguration(.init(font: .systemFont(ofSize: 80), scale: .default), forImageIn: .normal)
        button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        return button
    }()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        configure()
        configureNavigationController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationController()
        videoRecordingManager.requestPermissionAndShowCamera { [weak self] success in
            guard let self = self else { return }
            self.videoRecordingManager.setupCamera(with: self.cameraView, and: self.captureSession, and: self.fileOutput)
            self.captureSession.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Configuration
    private func configureNavigationController() {
        title = "Record a video"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(dismissAndSave))
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(cameraView)
        cameraView.addSubview(recordButton)
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func updateViews() {
        let recordButtonImage =  isRecording ? "stop.circle" : "smallcircle.fill.circle"
        recordButton.setImage(UIImage(systemName: recordButtonImage), for: .normal)
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Private - Helpers
    private func toggleRecordingMode() {
        guard let experience = experience, let title = experience.title else { return }
        if isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: URL.makeNewVideoURL(with: title), recordingDelegate: self)
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Private - Actions
    @objc private func dismissAndSave() {
        guard let experience = experience,
            let videoURL = videoURL,
            let coordinates = LocationManager.shared.getLocation()
            else { return }
        experience.video = videoURL.absoluteString
        experience.latitude = coordinates.latitude as Double
        experience.longitude = coordinates.longitude as Double
        try? CoreDataStack.shared.save()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func recordTapped() {
        toggleRecordingMode()
    }
}

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - AVCapture File Output Delegate
extension ExperienceVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        self.videoURL = outputFileURL
        updateViews()
    }
}
