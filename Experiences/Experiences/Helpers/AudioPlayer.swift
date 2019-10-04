//
//  AudioPlayer.swift
//  LambdaTimeline
//
//  Created by Michael Redig on 10/1/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation

protocol AudioPlayerDelegate: AnyObject {
	func playerDidChangeState(_ player: AudioPlayer)
	func playerPlaybackLoopUpdated(_ player: AudioPlayer)
}

class AudioPlayer: NSObject {
	let avPlayer: AVAudioPlayer
	private let playerQueue = DispatchQueue(label: "playerQueue")
	var isPlaying: Bool {
		playerQueue.sync {
			avPlayer.isPlaying
		}
	}
	var elapsedTime: TimeInterval {
		playerQueue.sync {
			avPlayer.currentTime
		}
	}
	var duration: TimeInterval {
		playerQueue.sync {
			avPlayer.duration
		}
	}
	var timeRemaining: TimeInterval {
		duration - elapsedTime
	}
	var currentFile: URL? {
		playerQueue.sync {
			avPlayer.url
		}
	}

	weak var delegate: AudioPlayerDelegate?

	private var timer: Timer?

	init(with file: URL) throws {
		avPlayer = try AVAudioPlayer(contentsOf: file)
		super.init()
		avPlayer.delegate = self
	}

	init(with data: Data) throws {
		avPlayer = try AVAudioPlayer(data: data)
		super.init()
		avPlayer.delegate = self
	}

	deinit {
		avPlayer.stop()
		stopTimer()
	}

	func play() {
		avPlayer.play()
		startTimer()
		notifyDelegate()
	}

	func pause() {
		avPlayer.pause()
		stopTimer()
		notifyDelegate()
	}

	func stop() {
		avPlayer.stop()
		stopTimer()
		notifyDelegate()
	}

	private func startTimer() {
		stopTimer()
		timer = Timer.scheduledTimer(withTimeInterval: 1 / 60.0, repeats: true, block: { [weak self] _ in
			guard let self = self else { return }
			self.delegate?.playerPlaybackLoopUpdated(self)
		})
	}

	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}

	private func notifyDelegate() {
		delegate?.playerDidChangeState(self)
	}

	/// figure out based on state what to do
	func playPause() {
		if isPlaying {
			pause()
		} else {
			play()
		}
	}
}

extension AudioPlayer: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		//TODO: Should we add a delegate protocol method?
		notifyDelegate()
	}

	func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
		//TODO: Should we propogate this error?
		if let error = error {
			NSLog("Error playing audio file: \(error)")
		}
		notifyDelegate()
	}
}
