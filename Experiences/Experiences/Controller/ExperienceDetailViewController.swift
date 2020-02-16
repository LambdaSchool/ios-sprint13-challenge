//
//  ExperienceDetailViewController.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/16/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import AVFoundation
import UIKit

class ExperienceDetailViewController: UIViewController {
    
    var manager = AudioManager()
    var player: AVQueuePlayer!
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()
    
    let videoLayerView: VideoContainerView = {
        let videoView = VideoContainerView()
        videoView.backgroundColor = .systemGray4
        videoView.layer.cornerRadius = 15
        videoView.clipsToBounds = true
        videoView.translatesAutoresizingMaskIntoConstraints = false
        return videoView
    }()
    
    let playVideoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(font: .systemFont(ofSize: 35), scale: .default), forImageIn: .normal)
        button.addTarget(self, action: #selector(videoPlayTapped), for: .touchUpInside)
        button.tintColor = .systemGreen
        return button
    }()
    
    let audioContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let audioVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let audioHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    let audioLabel: UILabel = {
        let label = UILabel()
        label.text = "Audio"
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let playAudioButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.setImage(UIImage(systemName: "pause.circle"), for: .selected)
        button.setPreferredSymbolConfiguration(.init(font: .systemFont(ofSize: 35), scale: .default), forImageIn: .normal)
        button.tintColor = .systemGreen
        button.addTarget(self, action: #selector(audioPlayTapped), for: .touchUpInside)
        return button
    }()
    
    let timeElapsedLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .label
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.value = 0
        return slider
    }()
    
    let timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.text = "-00:00"
        label.textColor = .label
        return label
    }()
    
    let experienceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        updateViews()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(videoLayerView)
        view.addSubview(audioContainerView)
        view.addSubview(experienceImageView)
        videoLayerView.addSubview(playVideoButton)
        audioContainerView.addSubview(audioVerticalStackView)
        audioContainerView.addSubview(playAudioButton)
        audioVerticalStackView.addArrangedSubview(audioLabel)
        audioVerticalStackView.addArrangedSubview(audioHorizontalStackView)
        audioHorizontalStackView.addArrangedSubview(timeElapsedLabel)
        audioHorizontalStackView.addArrangedSubview(slider)
        audioHorizontalStackView.addArrangedSubview(timeRemainingLabel)
        let sVPadding: CGFloat = 8
        NSLayoutConstraint.activate([
            videoLayerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            videoLayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            videoLayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            videoLayerView.heightAnchor.constraint(equalToConstant: 250),
            
            playVideoButton.trailingAnchor.constraint(equalTo: videoLayerView.trailingAnchor, constant: -16),
            playVideoButton.bottomAnchor.constraint(equalTo: videoLayerView.bottomAnchor, constant: -16),
            
            audioContainerView.topAnchor.constraint(equalTo: videoLayerView.bottomAnchor, constant: 16),
            audioContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            audioContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            audioContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            playAudioButton.topAnchor.constraint(equalTo: audioContainerView.topAnchor, constant: 8),
            playAudioButton.trailingAnchor.constraint(equalTo: audioContainerView.trailingAnchor, constant: -8),
            
            audioVerticalStackView.topAnchor.constraint(equalTo: audioContainerView.topAnchor, constant: sVPadding),
            audioVerticalStackView.leadingAnchor.constraint(equalTo: audioContainerView.leadingAnchor, constant: sVPadding),
            audioVerticalStackView.trailingAnchor.constraint(equalTo: audioContainerView.trailingAnchor, constant: -sVPadding),
            audioVerticalStackView.bottomAnchor.constraint(equalTo: audioContainerView.bottomAnchor, constant: -sVPadding),
            
            experienceImageView.topAnchor.constraint(equalTo: audioContainerView.bottomAnchor, constant: 20),
            experienceImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            experienceImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            experienceImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateViews() {
        guard let experience = experience,
            let title = experience.title,
            self.isViewLoaded else { return }
        self.title = title
        guard let audioURL = URL.fetchAudioFromDocumentsDirectory(name: title) else { return }
        manager.loadAudio(with: audioURL)
        manager.delegate = self
        updateAudioViews()
    }
    
    private func updateAudioViews() {
        playAudioButton.isSelected = manager.isPlaying
        let elapsedTime = manager.audioPlayer?.currentTime ?? 0
        timeElapsedLabel.text = timeIntervalFormatter.string(from: elapsedTime)
        slider.minimumValue = 0
        slider.maximumValue = Float(manager.audioPlayer?.duration ?? 0)
        slider.value = Float(elapsedTime)
        let timeRemaining = (manager.audioPlayer?.duration ?? 0) - elapsedTime
        timeRemainingLabel.text = "-\(timeIntervalFormatter.string(from: timeRemaining) ?? "")"
    }
    
    @objc private func audioPlayTapped() {
        manager.togglePlayMode()
    }
    
    @objc private func videoPlayTapped() {
        guard let experience = experience,
            let title = experience.title
            else { return }
        guard let videoURL = URL.fetchVideoFromDocumentsDirectory(name: title) else { return }
        player = AVQueuePlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoLayerView.frame
        videoLayerView.layer.addSublayer(playerLayer)
        videoLayerView.playerLayer = playerLayer
        videoLayerView.layer.masksToBounds = true
        player.play()
    }
}

extension ExperienceDetailViewController: AudioManagerDelegate {
    func isRecording() {
        return
    }
    
    func doneRecording(with url: URL) {
        return
    }
    
    func didPlay() {
        updateAudioViews()
    }
    
    func didPause() {
        updateAudioViews()
    }
    
    func didFinishPlaying() {
        updateAudioViews()
    }
    
    func didUpdate() {
        updateAudioViews()
    }
}
