//
//  AudioPlayer.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import AVFoundation


class AudioPlayer: NSObject {
	let name: String
	private var audioPlayer: AVAudioPlayer?
	var timer: Timer?
	
	init(name: String) {
		self.name = name
		
	}
	
	func setupPlayer() {
		
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		
		let url = documentsDirectory.appendingPathComponent(name).appendingPathExtension("caf")
		
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: url)
		} catch {
			NSLog("audioPlayer: \(error)")
		}
		audioPlayer?.play()
		print(url)
		//		timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
		//			self.updateTimer()
		//		}
	}
	func updateTimer() {
		//		NotificationCenter.default.post(name: .timerChangedValue, object: nil)
	}
	
	var isPlaying: Bool {
		return audioPlayer?.isPlaying ?? false
	}
	
	var elapsedTime: TimeInterval? {
		return audioPlayer?.currentTime
	}
	
	var duration: TimeInterval? {
		return audioPlayer?.duration
	}
	
	func play() {
		audioPlayer?.play()
		//starttimeer
	}
	
	func pause() {
		audioPlayer?.pause()
		//		timer?.invalidate()
		//		timer = nil
	}
}

extension AudioPlayer: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		//		timer?.invalidate()
		//		timer = nil
		NotificationCenter.default.post(name: .audioPlayerDidFinishPlaying, object: nil)
	}
}

extension Notification.Name {
	static let audioPlayerDidFinishPlaying =  Notification.Name("AudioPlayerDidFinishPlaying")
}
