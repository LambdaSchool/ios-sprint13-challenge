//
//  VideoSessionManager.swift
//  LambdaTimeline
//
//  Created by Michael Redig on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//
//swiftlint:disable private_over_fileprivate

import AVFoundation

protocol VideoSessionManagerDelegate: AnyObject {
	/// Gets called when the status changes, starting or stopping the session. `running` is true when the session is started, false, when it gets stopped.
	func videoSessionManager(_ manager: VideoSessionManager, didStartCaptureSession running: Bool)

	func videoSessionManager(_ manager: VideoSessionManager, didStartRecordingToURL url: URL)
	func videoSessionManager(_ manager: VideoSessionManager, didFinishRecordingToURL url: URL, error: Error?)
}

enum VideoSessionError: Error {
	case cannotAddInput
	case cannotCreateInput
	case requestedCameraNotAvailable
	case requestedAudioNotAvailable
	case cannotCreateFileOutput
}

class VideoSessionManager {
	private(set) lazy var captureSession = AVCaptureSession()
	private(set) lazy var fileOutput = AVCaptureMovieFileOutput()

	private lazy var delegateForwarder: DelegateForwarder = {
		let forwarder = DelegateForwarder()
		forwarder.delegate = self
		return forwarder
	}()

	weak var delegate: VideoSessionManagerDelegate?

	/// changing this does nothing at the moment (for future refactor)
	var cameraPosition: AVCaptureDevice.Position
	/// changing this has no effect at the moment (for future refactor)
	var capturePreset: AVCaptureSession.Preset
	/// Returns whether the capture session is currently running
	var isRunning: Bool {
		return captureSession.isRunning
	}
	/// Returns whether the capture session is currently recording
	var isRecording: Bool {
		return fileOutput.isRecording
	}

	init(cameraPosition: AVCaptureDevice.Position = .back, capturePreset: AVCaptureSession.Preset = .hd1280x720) throws {
		self.cameraPosition = cameraPosition
		self.capturePreset = capturePreset
		try setupCamera()
	}

	private func setupCamera() throws {
		captureSession.beginConfiguration()
		let camera = try getWideCamera()
		try addCameraInput(camera: camera)
		setPreset()
		let mic = try getAudioDevice()
		try addAudioDevice(device: mic)
		try addFileOutput(fileOutput: fileOutput)
		captureSession.commitConfiguration()
	}

	// MARK: - Session Control
	func startRunning() {
		if !isRunning {
			captureSession.startRunning()
			delegate?.videoSessionManager(self, didStartCaptureSession: true)
		}
	}

	func stopRunning() {
		if isRunning {
			captureSession.stopRunning()
			delegate?.videoSessionManager(self, didStartCaptureSession: false)
		}
	}

	func startRecording() {
		if !isRecording {
			fileOutput.startRecording(to: newTempURL(withFileExtension: "mov"), recordingDelegate: delegateForwarder)
		}
	}

	func stopRecording() {
		if isRecording {
			fileOutput.stopRecording()
		}
	}

	func recordToggle() {
		if isRecording {
			stopRecording()
		} else {
			startRecording()
		}
	}

	// MARK: - Camera Setup helpers
	private func addCameraInput(camera: AVCaptureDevice) throws {
		let cameraInput = try AVCaptureDeviceInput(device: camera)
		guard captureSession.canAddInput(cameraInput) else { throw VideoSessionError.cannotAddInput }
		captureSession.addInput(cameraInput)
	}

	@discardableResult private func setPreset() -> Bool {
		guard captureSession.canSetSessionPreset(capturePreset) else { return false }
		captureSession.sessionPreset = capturePreset
		return captureSession.sessionPreset == capturePreset
	}

	private func getWideCamera() throws -> AVCaptureDevice {
		if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition) {
			return device
		}

		if let device = AVCaptureDevice.default(for: .video) {
			NSLog("Back camera not an option. Falling back to default video device...")
			return device
		}

		throw VideoSessionError.requestedCameraNotAvailable
	}

	// MARK: - Audio Setup Helpers
	private func getAudioDevice() throws -> AVCaptureDevice {
		if let device = AVCaptureDevice.default(for: .audio) {
			return device
		}

		throw VideoSessionError.requestedAudioNotAvailable
	}

	private func addAudioDevice(device: AVCaptureDevice) throws {
		let audioInput = try AVCaptureDeviceInput(device: device)

		guard captureSession.canAddInput(audioInput) else { throw VideoSessionError.cannotAddInput }
		captureSession.addInput(audioInput)
	}

	// MARK: - Recording Setup Helpers
	private func addFileOutput(fileOutput: AVCaptureMovieFileOutput) throws {
		guard captureSession.canAddOutput(fileOutput) else { throw VideoSessionError.cannotCreateFileOutput }
		captureSession.addOutput(fileOutput)
	}

	// MARK: - Misc helpers
	private func newTempURL(withFileExtension fileExtension: String? = nil) -> URL {
		let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
		let name = UUID().uuidString
		let tempFile = tempDir.appendingPathComponent(name).appendingPathExtension(fileExtension ?? "")

		return tempFile
	}
}

// MARK: - Delegation
extension VideoSessionManager: DelegateForwarderDelegate {
	func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
		delegate?.videoSessionManager(self, didStartRecordingToURL: fileURL)
	}

	func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
		delegate?.videoSessionManager(self, didFinishRecordingToURL: outputFileURL, error: error)
	}
}

fileprivate protocol DelegateForwarderDelegate: AnyObject {
	func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection])
	func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?)
}

fileprivate class DelegateForwarder: NSObject, AVCaptureFileOutputRecordingDelegate {
	weak var delegate: DelegateForwarderDelegate?

	func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
		delegate?.fileOutput(output, didStartRecordingTo: fileURL, from: connections)
	}

	func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
		delegate?.fileOutput(output, didFinishRecordingTo: outputFileURL, from: connections, error: error)
	}
}
