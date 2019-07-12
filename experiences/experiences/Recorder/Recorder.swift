//
//  Recorder.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import AVFoundation



class Recorder: NSObject {
	private var audioRecorder: AVAudioRecorder?
	var fileUrl: URL?
	
	
	var isRecording: Bool {
		guard let audioRecorder = audioRecorder else { return false }
		return audioRecorder.isRecording
	}
	
	override init() {
		super.init()
	}
	
	func startRecord(with name: String) {
		let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		
		fileUrl = documentDirectory.appendingPathComponent(name).appendingPathExtension("caf")
		
		let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
		
		do {
			audioRecorder = try AVAudioRecorder(url: fileUrl!, format: format)
		} catch {
			NSLog("Error trying to AVAudioRecorder: \(error)")
		}
		
//		guard let audioRecorder = audioRecorder else {
//			print("error with audioRecorder!")
//			return
//		} 
		audioRecorder?.delegate = self
		audioRecorder?.record()
		print(fileUrl!)
	}
	
	func stop() {
		audioRecorder?.stop()
		audioRecorder = nil
	}
}

extension Recorder: AVAudioRecorderDelegate {
	func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
		if let error = error {
			fatalError("audioRecorderEncodeErrorDidOccur: \(error)")
		}
	}
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		NotificationCenter.default.post(name: .audioRecorderDidFinishRecording, object: nil)
		print("audioRecorderDidFinishRecording")
	}
}


extension Notification.Name {
	static let audioRecorderDidFinishRecording =  Notification.Name("AudioRecorderDidFinishRecording")
}
