//
//  AudioRecordingViewController.swift
//  Experiences
//
//  Created by Percy Ngan on 1/17/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecordingViewController: UIViewController, AVAudioRecorderDelegate {

	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK: - Properties
	var audioPlayer: AVAudioPlayer?
	var recorder: AVAudioRecorder!
	var session: AVAudioSession!

	var fileURL: URL? {
		guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }

		return dir.appendingPathComponent("audioRecording.m4a")
	}

	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK: - Outlets

	@IBOutlet weak var recordLabel: UILabel!
	@IBOutlet weak var audioRecordButton: UIButton!


	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK: - View Controller Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
	// MARK:- - Actions

	@IBAction func audioRecordButton(_ sender: Any) {
		if recorder == nil {

			guard let fileURL = fileURL else { return }
			let settings = [
				AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
				AVSampleRateKey: 12000,
				AVNumberOfChannelsKey: 1,
				AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
			]

			do {
				recorder = try AVAudioRecorder(url: fileURL, settings: settings)
				recorder.delegate = self
				recorder.record()
				recordLabel.text = "Recording Audio"
				audioRecordButton.setTitle("Stop", for: .normal)
			} catch {
				NSLog("There is an error recording: \(error)")
			}
		} else {

			let time = round(recorder.currentTime * 100) / 100

			recordLabel.text = "Recording duration: \(time) seconds"
			recorder.stop()
			recorder = nil
			audioRecordButton.setTitle("Record", for: .normal)
		}
	}


	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/

}
