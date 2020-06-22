//
//  VideoPlayerView.swift
//  LambdaTimeline
//
//  Created by Michael Redig on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoPlayerViewDelegate: AnyObject {
	func videoPlayerViewStatusChanged(_ videoPlayerView: VideoPlayerView)
}

class VideoPlayerView: UIView {
	private weak var player: AVPlayer?
	private weak var playerLayer: AVPlayerLayer?

	weak var delegate: VideoPlayerViewDelegate?

	private var stopNotification: NSObjectProtocol?

	override func awakeFromNib() {
		super.awakeFromNib()
		// gets notifications from OTHER views - come up with alternative
		stopNotification = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
																  object: nil,
																  queue: nil,
																  using: { [weak self] notification in
			guard let self = self else { return }
			if let notifyingPlayerItem = notification.object as? AVPlayerItem {
				if notifyingPlayerItem == self.player?.currentItem {
					self.stop()
					self.notifyDelegate()
					if self.shouldLoop {
						self.play()
					}
				}
			}
		})
	}

	deinit {
		stopNotification = nil
		print("player done")
	}

	var isPlaying: Bool {
		guard let player = player else { return false }
		return player.rate != 0 && player.error == nil
	}
	var shouldLoop: Bool = false
	var volume: Float {
		get { player?.volume ?? 0 }
		set { player?.volume = newValue }
	}

	func loadMovie(url: URL) {
		playerLayer?.removeFromSuperlayer()
		playerLayer = nil

		let newPlayer = AVPlayer(url: url)
		player = newPlayer
		let newPlayerLayer = AVPlayerLayer(player: player)
		newPlayerLayer.videoGravity = .resizeAspectFill
		playerLayer = newPlayerLayer
		playerLayer?.frame = bounds

		layer.addSublayer(newPlayerLayer)
		notifyDelegate()
	}

	func play() {
		player?.play()
		notifyDelegate()
	}

	func stop() {
		player?.pause()
		player?.seek(to: CMTime.zero)
		notifyDelegate()
	}

	func pause() {
		player?.pause()
		notifyDelegate()
	}

	func playPauseToggle() {
		if isPlaying {
			pause()
		} else {
			play()
		}
	}

	func playStopToggle() {
		if isPlaying {
			stop()
		} else {
			play()
		}
	}

	private func notifyDelegate() {
		delegate?.videoPlayerViewStatusChanged(self)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		playerLayer?.frame = bounds
	}
}
