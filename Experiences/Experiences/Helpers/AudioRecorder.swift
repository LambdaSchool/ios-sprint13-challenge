//
//  AudioRecorder.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import AVFoundation

protocol AudioRecorderDelegate {
	func recorderDidChangeState(_ recorder: AudioRecorder)
	func recorderDidFinishSavingFile(_ recorder: AudioRecorder, url: URL)
}

class AudioRecorder: NSObject {
	
	// MARK: - Properties
	
	private var audioRecorder: AVAudioRecorder?
	var delegate: AudioRecorderDelegate?
	var isRecording: Bool {
		audioRecorder?.isRecording ?? false
	}
	
	// MARK: - Life Cycle
	
	override init() {
		audioRecorder = nil //AVAudioRecorder()
		
		super.init()
	}
	
	// MARK: - Helpers
	
	func record() {
		#warning("Clean up file manager")
		let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
		print("Filename: \(name)")
		
		//.caf extension
		let file = documentDir.appendingPathComponent(name).appendingPathExtension("caf")
		let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
		
		audioRecorder = try! AVAudioRecorder(url: file, format: format)
		audioRecorder?.delegate = self
		audioRecorder?.record()
		
		notifyDelegate()
	}
	
	func stop() {
		audioRecorder?.stop()
		notifyDelegate()
	}
	
	func toggleRecording() {
		if isRecording {
			stop()
		} else {
			record()
		}
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
        print("audioRecorderDidFinishRecording")
		delegate?.recorderDidFinishSavingFile(self, url: recorder.url)
    }
}
