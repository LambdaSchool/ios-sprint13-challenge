//
//  AudioPlayer.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import AVFoundation

protocol AudioPlayerDelegate {
	func playerDidChangeState(_ player: AudioPlayer)
}

class AudioPlayer: NSObject {
	
	// MARK: - Properties
	
	var audioPlayer: AVAudioPlayer
	var delegate: AudioPlayerDelegate?
	var timer: Timer?
	var isPlaying: Bool {
		audioPlayer.isPlaying
	}
	var elapsedTime: TimeInterval {
		audioPlayer.currentTime
	}
	var timeRemaining: TimeInterval {
		audioPlayer.duration - elapsedTime
	}
	var duration: TimeInterval {
		audioPlayer.duration
	}
	
	// MARK: - Life Cycle
	
	init(with url: URL) throws {
		audioPlayer = try AVAudioPlayer(contentsOf: url)
		super.init()
		audioPlayer.delegate = self
	}
	
	init(with data: Data) throws {
		audioPlayer = try AVAudioPlayer(data: data)
		super.init()
		audioPlayer.delegate = self
	}
	
	// MARK: - Helpers
	
	func load(url: URL) throws {
		audioPlayer = try AVAudioPlayer(contentsOf: url)
	}
	
	func play() {
		audioPlayer.play()
		startTimer()
		notifyDelegate()
	}
	
	func pause() {
		audioPlayer.pause()
		stopTimer()
		notifyDelegate()
	}
	
	func playPause() {
		if isPlaying {
			pause()
		} else {
			play()
		}
	}
	
	func stop() {
		audioPlayer.stop()
	}
	
	private func notifyDelegate() {
		delegate?.playerDidChangeState(self)
	}
	
	private func startTimer() {
		stopTimer()
		timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (_) in
			self.notifyDelegate()
		})
	}
	
	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
}

extension AudioPlayer: AVAudioPlayerDelegate {
	func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
		if let error = error {
			print("Error playing audio file: \(error)")
		}
		notifyDelegate()
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		stopTimer()
		notifyDelegate()
	}
}
