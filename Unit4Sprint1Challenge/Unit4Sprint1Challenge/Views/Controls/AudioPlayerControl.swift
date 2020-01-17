//
//  AudioPlayerControl.swift
//  LambdaTimeline
//
//  Created by Jon Bash on 2020-01-14.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class AudioPlayerControl: UIControl {

    // MARK: - UI Elements

    private(set) var playPauseButton = UIButton(type: .system)
    private(set) var timeSlider = UISlider()

    private var timestampLabel = UILabel()
    private var timeRemainingLabel = UILabel()

    private var verticalStack: UIStackView!
    private var sliderStack: UIStackView!

    private var timeFormatter: DateComponentsFormatter {
        DateComponentsFormatter.audioTimeFormatter
    }

    // MARK: - Audio Properties

    var audioIsLoaded: Bool { audioPlayer != nil }
    var isPlaying: Bool { audioPlayer?.isPlaying ?? false }
    var elapsedTime: TimeInterval { audioPlayer?.currentTime ?? 0 }
    var totalDuration: TimeInterval { audioPlayer?.duration ?? 0 }
    var timeRemaining: TimeInterval { totalDuration - elapsedTime }

    private var audioPlayer: AVAudioPlayer?
    private var uiUpdateTimer: Timer?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubViews()
    }

    // MARK: - UI Actions

    @objc
    private func playPauseButtonTapped(_ sender: UIButton) {
        togglePlayback()
    }

    // MARK: - Playback API

    func loadAudio(from url: URL) {
        do { audioPlayer = try AVAudioPlayer(contentsOf: url) } catch {
            print("error loading audio player from url: \(error)")
            return
        }
        audioPlayer?.delegate = self
        updateViews()
    }

    func loadAudio(from data: Data) {
        do { audioPlayer = try AVAudioPlayer(data: data) } catch {
            print("error loading audioplayer from data: \(error)")
            return
        }
        audioPlayer?.delegate = self
        updateViews()
    }

    func unloadAudio() {
        audioPlayer = nil
    }

    func togglePlayback() {
        isPlaying ? pause() : play()
    }

    func play() {
        audioPlayer?.play()
        updateViews()
        startUIUpdateTimer()
    }

    func pause() {
        audioPlayer?.pause()
        updateViews()
        killUIUpdateTimer()
    }

    // MARK: - Helper Methods

    private func updateViews() {
        playPauseButton.setTitle(isPlaying ? "Pause" : "Play", for: .normal)
        timestampLabel.text = timeFormatter.string(from: elapsedTime)
        timeRemainingLabel.text = timeFormatter.string(from: timeRemaining)
        if !isPlaying {
            timeSlider.maximumValue = Float(totalDuration)
        }
        timeSlider.value = Float(elapsedTime)
    }

    private func startUIUpdateTimer() {
        killUIUpdateTimer()
        uiUpdateTimer = Timer.scheduledTimer(
            timeInterval: 0.03,
            target: self,
            selector: #selector(updateUITimer(_:)),
            userInfo: nil,
            repeats: true)
    }

    private func killUIUpdateTimer() {
        uiUpdateTimer?.invalidate()
        uiUpdateTimer = nil
    }

    @objc
    private func updateUITimer(_ timer: Timer) {
        updateViews()
    }

    private func setUpSubViews() {
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.addTarget(
            self,
            action: #selector(playPauseButtonTapped(_:)),
            for: .touchUpInside)

        let sliderHHuggingPriority = timeSlider
            .contentHuggingPriority(for: .horizontal) - 2
        timeSlider.setContentHuggingPriority(
            sliderHHuggingPriority, for: .horizontal)

        sliderStack = UIStackView(arrangedSubviews: [
            timestampLabel,
            timeSlider,
            timeRemainingLabel])
        sliderStack.axis = .horizontal
        sliderStack.alignment = .fill
        sliderStack.distribution = .fill
        sliderStack.spacing = 8

        verticalStack = UIStackView(arrangedSubviews: [
            playPauseButton,
            sliderStack])
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .fill

        self.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderStack.leadingAnchor.constraint(
                equalTo: verticalStack.leadingAnchor,
                constant: 4),
            sliderStack.trailingAnchor.constraint(
                equalTo: verticalStack.trailingAnchor,
                constant: -4),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStack.topAnchor.constraint(equalTo: topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor)])

        updateViews()
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayerControl: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio player decode error: \(error)")
        }
    }
}
