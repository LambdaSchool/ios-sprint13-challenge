//
//  PlaybackViewController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class PlaybackViewController: UIViewController {

	@IBOutlet private var audioContainer: UIView!
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var videoPlayerView: VideoPlayerView!
	@IBOutlet private var labelContainer: UIView!
	@IBOutlet private var titleLabel: UILabel!

	var audioPlayer: AudioPlayer?

	var experience: Experience? {
		didSet {
			updateViews()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		updateViews()
	}

	private func updateViews() {
		guard isViewLoaded else { return }
		audioContainer.isHidden = true
		imageView.isHidden = true
		videoPlayerView.isHidden = true
		labelContainer.layer.cornerRadius = 10
		guard let experience = experience, let type = experience.experienceType else { return }
		switch type {
		case .audio:
			updateAudio(experience: experience)
		case .photo:
			updateImage(experience: experience)
		case .video:
			updateVideo(experience: experience)
		}
		titleLabel.text = experience.title
	}

	private func updateImage(experience: Experience) {
		guard let url = experience.fullURL else { return }
		imageView.isHidden = false
		let image = UIImage(contentsOfFile: url.path)
		imageView.image = image
	}

	private func updateVideo(experience: Experience) {
		guard let url = experience.fullURL else { return }
		videoPlayerView.isHidden = false
		videoPlayerView.loadMovie(url: url)
		videoPlayerView.play()
	}

	private func updateAudio(experience: Experience) {
		guard let url = experience.fullURL else { return }
		audioContainer.isHidden = false
		audioPlayer = try? AudioPlayer(with: url)
	}

	@IBAction func playAudioPressed(_ sender: UIButton) {
		audioPlayer?.playPause()
	}
}
