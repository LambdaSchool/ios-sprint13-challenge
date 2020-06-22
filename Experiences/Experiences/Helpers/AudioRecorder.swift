//
//  AudioRecorder.swift
//  LambdaTimeline
//
//  Created by Michael Redig on 10/1/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation

protocol AudioRecorderDelegate: AnyObject {
	func recorderDidChangeState(_ recorder: AudioRecorder)
	func recorderLoopUpdated(_ recorder: AudioRecorder)
	func recorderDidFinishSavingFile(_ recorder: AudioRecorder, url: URL)
}

class AudioRecorder: NSObject {
	static var newTmpFilehandle: URL {
		let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory())
		let name = UUID().uuidString

		let file = tmpDir.appendingPathComponent(name).appendingPathExtension("caf")
		return file
	}

	private let avRecorder: AVAudioRecorder
	weak var delegate: AudioRecorderDelegate?
	private var timer: Timer?

	var isRecording: Bool {
		avRecorder.isRecording
	}

	var currentTime: TimeInterval {
		avRecorder.currentTime
	}

	/// initializes a new recording to the file location specified
	init(recordingTo file: URL) throws {
		guard let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1) else { fatalError("Bad audio format") }
		avRecorder = try AVAudioRecorder(url: file, format: format)
		avRecorder.prepareToRecord()
		super.init()
		avRecorder.delegate = self
	}

	/// initializes a new recording to the tmp directory
	override init() {
		let file = AudioRecorder.newTmpFilehandle

		guard let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1) else { fatalError("Bad audio format") }
		do {
			avRecorder = try AVAudioRecorder(url: file, format: format)
		} catch {
			NSLog("Error creating recording: \(error)")
			fatalError("Error creating recording: \(error)")
		}
		avRecorder.prepareToRecord()

		super.init()
		avRecorder.delegate = self
	}

	deinit {
		if isRecording {
			avRecorder.stop() // save to disk
		}
		stopTimer()
	}

	func record() {
		avRecorder.record()
		notifyDelegate()
		startTimer()
	}

	func stop() {
		avRecorder.stop() // save to disk
		notifyDelegate()
		stopTimer()
	}

	func toggleRecording() {
		if isRecording {
			stop()
		} else {
			record()
		}
	}

	private func startTimer() {
		stopTimer()
		timer = Timer.scheduledTimer(withTimeInterval: 1 / 60.0, repeats: true, block: { [weak self] _ in
			guard let self = self else { return }
			self.delegate?.recorderLoopUpdated(self)
		})
	}

	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}

	private func notifyDelegate() {
		delegate?.recorderDidChangeState(self)
	}
}

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("audioRecorderEncodeErrorDidOccur: \(error)")
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		delegate?.recorderDidFinishSavingFile(self, url: recorder.url)
    }
}
